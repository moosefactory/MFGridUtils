//   /\/\__/\/\      􀮟 MFGridUtils
//   \/\/..\/\/      Efficient grid scanning
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFGridSize.swift
//  􀓣 Created by Tristan Leblanc on 22/12/2024.

import Foundation
import MFFoundation

/// Use GridSize to define integer size
public struct MFGridSize: Codable {
    
    enum Errors: Error {
        case gridDimensionMustBeGreaterOrEqualToZero
    }
    
    static let zero = MFGridSize(size: 0)
    
    public var columns: Int { didSet {
        numberOfCells = columns * rows
    }}
    
    public var rows: Int { didSet {
        numberOfCells = columns * rows
    }}
    
    /// The number of cells in the grid.
    /// This property is recomputed each time the size is changed
    public private(set) var numberOfCells: Int

    /// The cell size in [0.0, 1.0] range.
    /// That's all we have unless we provide a grid or a cell size.
    public private(set) var fractionalCellSize: CGSize

    // MARK: - Initialisation
    
    /// Init a square grid

    public init(size: UInt) {
        self.columns = Int(size)
        self.rows = Int(size)
        numberOfCells = columns * rows
        fractionalCellSize = CGSize(width: 1.0 / CGFloat(columns),
                                    height: 1.0 / CGFloat(rows))
    }

    /// Init a rectangular grid
    
    public init(columns: UInt, rows: UInt) {
        self.columns = Int(columns)
        self.rows = Int(rows)
        numberOfCells = Int(columns * rows)
        fractionalCellSize = CGSize(width: 1.0 / CGFloat(columns),
                                    height: 1.0 / CGFloat(rows))
    }
    
    public init(columns: Int, rows: Int) throws {
        guard columns >= 0, rows >= 0 else {
            throw Errors.gridDimensionMustBeGreaterOrEqualToZero
        }
        self.columns = columns
        self.rows = rows
        numberOfCells = columns * rows
        fractionalCellSize = CGSize(width: 1.0 / CGFloat(columns),
                                    height: 1.0 / CGFloat(rows))
    }

    /// Returns columns and rows as CGFloats values
    
    @inlinable public var asCGFloat: (columns: CGFloat, rows: CGFloat) {
        (columns: CGFloat(columns), rows: CGFloat(rows))
    }
    
    /// Returns columns and rows as a CGSize
    /// Note this is a simple cast of the column and row indexes from integer to float size
    /// To compute the full grid frame, use 'frameSize(for cellsize:CGSize)' function

    public var asCGSize: CGSize {
        CGSize(width: columns, height: rows)
    }
    
    /// Returns columns and rows as C floats values
    
    @inlinable public var asCFloat: (columns: CFloat, rows: CFloat) {
        (columns: CFloat(columns), rows: CFloat(rows))
    }
    
    /// Returns columns and rows as CInts values
    
    @inlinable public var asCInt: (columns: CInt, rows: CInt) {
        (columns: CInt(columns), rows: CInt(rows))
    }
    
    /// Returns the grid frame size for a given cell size
    
    public func frameSize(for cellSize: CGSize) -> CGSize {
        return CGSize(width: CGFloat(columns) * cellSize.width, height: CGFloat(rows) * cellSize.height)
    }
    /// Returns the grid frame for passed cell size
    
    public func frame(for cellSize: CGSize) -> CGRect {
        return CGRect(origin: .zero, size: frameSize(for: cellSize))
    }

    /// Returns a random location in grid

    public func random() -> MFGridLocation {
        MFGridLocation(h: Int.random(max: columns - 1),
                     v: Int.random(max: rows - 1) )
    }

    /// clamp a gridlocation to grid size

    public func containsGridLocation(_ gridLocation: MFGridLocation) -> Bool {
        gridLocation.h >= 0
        && gridLocation.v >= 0
        && gridLocation.h <= columns - 1
        && gridLocation.v <= rows - 1
    }

    /// clamp a grid location to grid size

    public func clamp(gridLocation: MFGridLocation) -> MFGridLocation {
        MFGridLocation(h: min( max(0, gridLocation.h), columns - 1),
                       v: min( max(0, gridLocation.v), rows - 1))
    }

    /// grow a grid on both dimensions by the passed amount
    
    public func grownBy(_ amount: UInt32) -> MFGridSize {
        // we force unwrap because we will never go negative by adding one
       try! MFGridSize(columns: columns + Int(amount), rows: rows + Int(amount) )
    }
}

public extension MFGridSize {
    
    // Returns a grid scanner 
    func scanner() -> MFGridScanner {
        MFGridScanner(with: MFGrid(gridSize: self))
    }
}

extension MFGridSize: CustomStringConvertible {
    
    public var description: String {
        "\(columns)x\(rows)"
    }
}

public extension MFGrid {
    
    // Returns a grid scanner
    func scanner() -> MFGridScanner {
        MFGridScanner(with: self)
    }
}

public extension CGSize {
    
    /// Converts a CGSize to a grid size
    var asGridSize: MFGridSize {
        MFGridSize(columns: UInt(abs(width)), rows: UInt(abs(height)))
    }
}

