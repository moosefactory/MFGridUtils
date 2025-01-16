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
    
    class Scanner {
        
        /// Scanners use a cell object that is created before the scan and updated in the loops.
        /// All values updates are made using additions, which make the scanner quite fast.
        public class Cell: CustomStringConvertible {
            
            public var description: String {
                [
                    "Cell #\(index) \(gridLocation) \(fractionalFrame)"
                ].joinedByReturn
            }
            
            /// The index of the cell
            /// Can be used to map to arrays or buffers
            
            public fileprivate(set) var index: Int = 0
            
            /// The location in grid ( column, row) of the cell
            
            public fileprivate(set) var gridLocation: MFGridLocation = .zero
            
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
            
            /// An optional grid.
            /// Scanner can be created with a grid, heriting of its gridSize and cellSize properties
            /// If a data grid is set, the data can be accessed more easily and safely in the iterator
            
            public fileprivate(set) var grid: MFGrid?
            
            // MARK: - Computed Properties
            
            var key: MFGridLocation { gridLocation }
            
            // Initialize  new cell attached to the given grid
            
            public init(grid: MFGrid) {
                self.cellSize = grid.cellSize
                self.frame =  CGRect(origin: .zero, size: grid.cellSize)
                self.fractionalFrame.size = grid.gridSize.fractionalCellSize
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
            let gridRect = gridRect ?? grid.gridRect
            
            cell = Cell(grid: grid)
            for j in gridRect.origin.v ..< gridRect.size.rows {
                cell.frame?.origin.x = 0
                cell.fractionalFrame.origin.x = 0
                for i in gridRect.origin.h ..< gridRect.size.columns {
                    block(self)
                    cell.index += 1
                    cell.gridLocation = MFGridLocation(h: i, v: j)
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
                block(self)
                cell.index += 1
                cell.gridLocation = MFGridLocation(h: i, v: row)
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
                block(self)
                cell.index += grid.gridSize.rows
                cell.gridLocation = MFGridLocation(h: column, v: j)
                cell.fractionalFrame.origin.y += grid.gridSize.fractionalCellSize.height
                if let cellSize = cell.cellSize {
                    cell.frame?.origin.y += cellSize.height
                }
            }
        }
        
        /// TODO: Move in procedural scanner

        public func scanDiagonal(offset: (h: Int, v: Int), _ block: (MFGridLocation)->Void) {
            var i: Int = min(offset.h, grid.gridSize.columns - 1)
            var j: Int = min(offset.v, grid.gridSize.rows - 1)
            while i < grid.gridSize.columns && j < grid.gridSize.rows {
                block(MFGridLocation(h: i, v: j))
                i += 1
                j += 1
            }
        }
    }
}
