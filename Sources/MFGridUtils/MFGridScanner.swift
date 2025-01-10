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

open class MFGridScanner {
    
    /// The size of the grid to scan
    
    public var gridSize: MFGridSize

    /// An optional reference to a grid object
    public weak var grid: MFGrid?

    // MARK: - Initializers
    
    public init(grid: MFGrid) {
        self.grid = grid
        self.gridSize = grid.gridSize
    }
    
    public init(gridSize: MFGridSize) {
        self.gridSize = gridSize
    }

    // MARK: - Scan
    
    /// Scans a grid by passing cell array index and location in grid to block
    
    public func scan(_ block: @escaping MFGridLocationClosure) {
        var index = 0
        for j in 0 ..< gridSize.rows {
            for i in 0 ..< gridSize.columns {
                block(MFGridLocation(h: i, v: j))
                index += 1
            }
        }
    }
    
    public func scanIndexed(_ block: @escaping MFGridIndexedLocationClosure) {
        var index = 0
        for j in 0 ..< gridSize.rows {
            for i in 0 ..< gridSize.columns {
                block(index, MFGridLocation(h: i, v: j))
                index += 1
            }
        }
    }
    
    /// Scan a single row.
    
    public func scanRow(_ row: Int = 0, _ block: @escaping MFGridLocationClosure) {
        for i in 0 ..< gridSize.columns {
            block(MFGridLocation(h: i, v: row))
        }
    }
    
    /// Scan a single column.
    
    public func scanColumn(_ column: Int = 0, _ block: @escaping MFGridLocationClosure) {
        for j in 0 ..< gridSize.rows {
            block(MFGridLocation(h: column, v: j))
        }
    }
    
    /// Scans a grid by passing:
    /// - cell index
    /// - location in grid
    /// - fractional location in frame ( 0..1, 0..1 )
    /// - location in grid frame ( 0..width, 0..height )
    ///
    public func gridScan(grid: MFGrid,
                        _ block: @escaping MFGridGeoScanClosure) {
        geometricScan(cellSize: grid.cellSize, block)
    }
    
    public func geometricScan(cellSize: CGSize,
                              _ block: @escaping MFGridGeoScanClosure) {
        let cell = MFGeoGridCell(gridLocation: .zero,
                                 cellSize: cellSize)

        for j in 0 ..< gridSize.rows {
            for i in 0 ..< gridSize.columns {
                cell.gridLocation = MFGridLocation(h: i, v: j)
                block(cell)
            }
        }
    }
    
    public func geometricIndexedScan(cellSize: CGSize,
                              _ block: @escaping MFGridGeoScanIndexedClosure) {
        var index = 0
        let cell = MFGeoGridCell(gridLocation: .zero,
                                 cellSize: cellSize)

        for j in 0 ..< gridSize.rows {
            for i in 0 ..< gridSize.columns {
                cell.gridLocation = MFGridLocation(h: i, v: j)
                block(index, cell)
                index += 1
            }
        }
    }
    
    /// Scans a grid by passing:
    /// - cell index
    /// - location in grid
    /// - fractional location in frame ( 0..1, 0..1 )
    /// - location in grid frame ( 0..width, 0..height )
    public func geometricScanRow(_ row: Int = 0, grid: MFGrid, _ block: @escaping MFGridGeoScanClosure) {
        let cellSize = grid.cellSize

        for i in 0 ..< gridSize.columns {
            let cell = MFGeoGridCell(gridLocation: MFGridLocation(h: i, v: row),
                                     cellSize: cellSize)
            block(cell)
        }
    }
    
    /// Scans a grid by passing:
    /// - cell index
    /// - location in grid
    /// - fractional location in frame ( 0..1, 0..1 )
    /// - location in grid frame ( 0..width, 0..height )
    public func geometricScanColumn(_ column: Int = 0, grid: MFGrid, _ block: @escaping MFGridGeoScanClosure) {
        let cellSize = grid.cellSize
        for j in 0 ..< gridSize.columns {
            let cell = MFGeoGridCell(gridLocation: MFGridLocation(h: column, v: j),
                                     cellSize: cellSize)
            block(cell)
        }
    }
    
    
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
