//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  GridScanner.swift
//  Created by Tristan Leblanc on 22/12/2024.

import Foundation

/// Sequentially scans a grid
///
/// MFGridScanner can be constructed from a MFGrid object,
/// or simply with a MFGridSize.

public typealias MFGridScannerIndexAndLocationClosure = (Int, MFGridLocation)->Void
public typealias MFGridScannerClosure = (MFGridScanner)->Void

open class MFGridScanner {
    
    
    public class Cell {
        
        public init(size: CGSize? = nil) {
            self.cellSize = size
            self.frame = size != nil ? CGRect(origin: .zero, size: size!) : nil
        }
        
        /// The index of the cell
        /// Can be used to map to arrays or buffers
        public var index: UInt = 0
        
        /// The location in grid ( column, row) of the cell
        public var gridLocation: MFGridLocation = .zero
        
        /// The frame of the cell, in [0.0,1.0] range
        /// Bottom left frame is {0, 0, 1.0 / gridSize.columns, 1.0 / gridSize.rows)
        public var fractionalFrame: CGRect = .zero

        /// An optional cell size.
        /// Cell size must be set to compute the following geometric properties
        public var cellSize: CGSize?
        
        /// The frame of the cell, in grid frame coordinates
        /// Bottom left frame is {0,0,cellSize.width, cellSize.height)
        public var frame: CGRect?
        
        /// An optional grid.
        /// Scanner can be created with a grid, heriting of its gridSize and cellSize properties
        /// If a data grid is set, the data can be accessed more easily and safely in the iterator
        public var grid: MFGrid?

        public var key: MFGridLocationKey { gridLocation.asKey }
    }
    
    /// The size of the grid to scan.
    /// If the scanner is created with a grid, grid size is set to the grid size
    public let gridSize: MFGridSize

    /// An optional reference to a grid object
    public let grid: MFGrid?

    /// An optional reference to a grid object
    public var cell = Cell()
    
    // MARK: - Initializers
    
    public init(with grid: MFGrid) {
        self.grid = grid
        self.gridSize = grid.gridSize
    }
    
    public init(with gridSize: MFGridSize) {
        self.grid = nil
        self.gridSize = gridSize
    }

    // MARK: - Scan
    
    /// Scans a grid by passing index and gridLocation in closure
    /// The fastest scan
    
    public func scan(_ block: @escaping MFGridScannerIndexAndLocationClosure) {
        var index: Int = 0
        for j in 0 ..< gridSize.rows {
            for i in 0 ..< gridSize.columns {
                block(index, MFGridLocation(h: i, v: j))
                cell.index += 1
                cell.gridLocation = MFGridLocation(h: i, v: j)
            }
        }
    }
    
    /// Scans a grid by passing cell in closure
    
    public func cellScan(_ block: @escaping MFGridScannerClosure) {
        let  cell = Cell(size: grid?.cellSize)
        for j in 0 ..< gridSize.rows {
            cell.frame?.origin.x = 0
            for i in 0 ..< gridSize.columns {
                block(self)
                cell.index += 1
                cell.gridLocation = MFGridLocation(h: i, v: j)
                cell.fractionalFrame.origin.x += gridSize.fractionalCellSize.width
            }
            cell.fractionalFrame.origin.y += gridSize.fractionalCellSize.height
            if let cellSize = cell.cellSize {
                cell.frame?.origin.y += cellSize.height
            }
        }
    }

    public func scanRow(_ row: Int = 0, _ block: @escaping MFGridScannerClosure) {
        let cell = Cell()
        for _ in 0 ..< gridSize.columns {
            block(self)
            cell.index += 1
        }
    }
    
    /// Scan a single column.
    
    public func scanColumn(_ column: Int = 0, _ block: @escaping MFGridScannerClosure) {
        let cell = Cell()
        for _ in 0 ..< gridSize.rows {
            block(self)
            cell.index += UInt(gridSize.columns)
        }
    }
    
    /// TODO: Move in procedural scanner
    public func scanDiagonal(offset: (h: Int, v: Int), _ block: (MFGridLocation)->Void) {
        var i: Int = min(offset.h, gridSize.columns - 1)
        var j: Int = min(offset.v, gridSize.rows - 1)
        while i < gridSize.columns && j < gridSize.rows {
            block(MFGridLocation(h: i, v: j))
            i += 1
            j += 1
        }
    }
}
