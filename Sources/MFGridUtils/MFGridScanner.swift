//   /\/\__/\/\      􀮟 MFGridUtils
//   \/\/..\/\/      Efficient grid scanning
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  􀈿 GridScanner.swift
//  􀓣 Created by Tristan Leblanc on 22/12/2024.


import Foundation
import MFFoundation

/// Sequentially scans a grid
///
/// MFGridScanner can be constructed from a MFGrid object,
/// or simply with a MFGridSize.

public typealias MFGridScanner = MFGrid.Scanner
public typealias MFGridScannerCell = MFGrid.Scanner.Cell

public typealias MFGridScannerIndexAndLocationClosure = (Int, MFGridLocation)->Void
public typealias MFGridScannerClosure = (MFGridScanner)->Void

public extension MFGrid {
    /// Scans a grid row by row from bottom left corner
    
    open class Scanner {
        
        /// Scanners use a cell object that is created before the scan and updated in the loops.
        /// All values updates are made using additions, which make the scanner quite fast.
        public class Cell: MFGridCellProtocol, CustomStringConvertible {
            
            public var description: String {
                [
                    "Cell #\(index) \(gridLocation) \(fractionalFrame)"
                ].joinedByReturn
            }
            
            /// The index of the cell
            /// Can be used to map to arrays or buffers
            
            public fileprivate(set) var index: Int = 0
            
            /// The location in grid ( column, row) of the cell
            
            public var gridLocation: MFGridLocation
            
            /// The frame of the cell, in [0.0,1.0] range
            /// Bottom left frame is {0, 0, 1.0 / gridSize.columns, 1.0 / gridSize.rows)
            
            public fileprivate(set) var fractionalFrame: CGRect = .zero
            
            /// An optional cell size.
            /// Cell size must be set to compute the geometric properties below
            
            public fileprivate(set) var cellSize: CGSize?
            
            // MARK: - Geometric Properties
            
            /// The frame of the cell, in grid frame coordinates
            /// Bottom left frame is {0,0,cellSize.width, cellSize.height)
            
            public fileprivate(set) var frame: CGRect?
       
            public var location: CGPoint? { frame?.origin }
            
            public var fractionalLocation: CGPoint { fractionalFrame.origin }

            /// An optional grid.
            /// Scanner can be created with a grid, heriting of its gridSize and cellSize properties
            /// If a data grid is set, the data can be accessed more easily and safely in the iterator
            
            public fileprivate(set) var grid: MFGrid?
            
            // MARK: - Computed Properties
            
            var key: MFGridLocation { gridLocation }
            
            // Initialize  new cell attached to the given grid
            
            public init(grid: MFGrid, gridLocation: MFGridLocation = .zero) {
                self.cellSize = grid.cellSize
                self.frame =  CGRect(origin: .zero, size: grid.cellSize)
                self.fractionalFrame.size = grid.gridSize.fractionalCellSize
                self.gridLocation = gridLocation
            }
        }
        
        /// A reference to a grid object
        
        public let grid: MFGrid
        
        /// The cell object that is updated during loops
        ///
        /// Note that you can't use the same scanner from two different threads, since this object is modified.
        
        public private(set) var cell: Cell!
        
        // MARK: - Initializers
        
        /// Initialize a new scanner on the passed grid
        /// - Parameter grid: The grid to scan
        
        public init(with grid: MFGrid) {
            self.grid = grid
        }
        
        // MARK: - Scan
        
        /// Scans a grid by passing index and gridLocation in closure
        /// The fastest scan
        
        public func scan(_ block: @escaping MFGridScannerIndexAndLocationClosure) {
            var index: Int = 0
            for j in 0 ..< grid.gridSize.rows {
                for i in 0 ..< grid.gridSize.columns {
                    block(index, MFGridLocation(h: i, v: j))
                    index += 1
                }
            }
        }
        
        /// Scans a grid by passing cell in closure
        
        public func cellScan(in gridRect: MFGridRect? = nil,
                             _ block: @escaping MFGridScannerClosure) {
           
            // If there is no clipping, we scan the full grid
            let gridRect = gridRect ?? grid.gridRect
            
            guard let originCell = grid.cell(at: gridRect.origin) else { return }

            let startX = originCell.location?.x ?? 0
            let startXf = originCell.fractionalLocation.x
            let lastRow = min(gridRect.origin.v + gridRect.size.rows, grid.gridSize.rows)
            let lastColumn = min(gridRect.origin.h + gridRect.size.columns, grid.gridSize.columns)

            cell = originCell
            for j in gridRect.origin.v ..< lastRow {
                cell.frame?.origin.x = startX
                cell.fractionalFrame.origin.x = startXf
                for i in gridRect.origin.h ..< lastColumn {
                    cell.gridLocation = MFGridLocation(h: i, v: j)
                    block(self)
                    cell.index += 1
                    cell.fractionalFrame.origin.x += grid.gridSize.fractionalCellSize.width
                    if let cellSize = cell.cellSize {
                        cell.frame?.origin.x += cellSize.width
                    }
                }
                cell.fractionalFrame.origin.y += grid.gridSize.fractionalCellSize.height
                if let cellSize = cell.cellSize {
                    cell.frame?.origin.y += cellSize.height
                }
            }
        }
        
        /// Scan a single row

        public func scanRow(_ row: Int = 0, _ block: @escaping MFGridScannerClosure) {
            cell = Cell(grid: grid)
            for i in 0 ..< grid.gridSize.columns {
                cell.gridLocation = MFGridLocation(h: i, v: row)
                block(self)
                cell.index += 1
                cell.fractionalFrame.origin.x += grid.gridSize.fractionalCellSize.width
                if let cellSize = cell.cellSize {
                    cell.frame?.origin.x += cellSize.width
                }
            }
        }
        
        /// Scan a single column
        
        public func scanColumn(_ column: Int = 0, _ block: @escaping MFGridScannerClosure) {
            cell = Cell(grid: grid)
            for j in 0 ..< grid.gridSize.rows {
                cell.gridLocation = MFGridLocation(h: column, v: j)
                block(self)
                cell.index += grid.gridSize.rows
                cell.fractionalFrame.origin.y += grid.gridSize.fractionalCellSize.height
                if let cellSize = cell.cellSize {
                    cell.frame?.origin.y += cellSize.height
                }
            }
        }
    }
}
