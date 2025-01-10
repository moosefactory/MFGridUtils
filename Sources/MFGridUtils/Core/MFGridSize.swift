//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFGridSize.swift
//  Created by Tristan Leblanc on 22/12/2024.

import Foundation
import MFFoundation

/// Use GridSize to define integer size
public struct MFGridSize: Codable {
    
    enum Errors: Error {
        case gridDimensionMustBeGreaterThanZero
    }
    
    public let columns: Int
    public let rows: Int
    
    public let numberOfCells: Int

    // MARK: - Initialisation
    
    /// Init a square grid

    public init(size: UInt) throws {
        self.columns = Int(size)
        self.rows = Int(size)
        numberOfCells = columns * rows
    }

    /// Init a rectangular grid
    
    public init(columns: UInt, rows: UInt) {
        self.columns = Int(columns)
        self.rows = Int(rows)
        numberOfCells = Int(columns * rows)
    }
    
    public init(columns: Int, rows: Int) throws {
        guard columns > 0, rows > 0 else {
            throw Errors.gridDimensionMustBeGreaterThanZero
        }
        self.columns = columns
        self.rows = rows
        numberOfCells = columns * rows
    }

    /// Returns columns and rows as CGFloats values
    
    @inlinable public var asCGFloat: (columns: CGFloat, rows: CGFloat) {
        (columns: CGFloat(columns), rows: CGFloat(rows))
    }
    
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

    /// Gives the cell dimensions as values between 0 and 1
    
    public var fractionalSize: CGSize {
        CGSize(width: 1.0 / CGFloat(columns), height: 1.0 / CGFloat(rows))
    }
    
    /// Returns the grid frame size for passed cell size
    
    public func frameSize(for cellSize: CGSize) -> CGSize {
        return CGSize(width: CGFloat(columns) * cellSize.width, height: CGFloat(rows) * cellSize.height)
    }
    /// Returns the grid frame for passed cell size
    
    public func frame(for cellSize: CGSize) -> CGRect {
        return CGRect(origin: .zero, size: frameSize(for: cellSize))
    }

    /// Returns a random point in grid

    public func random() -> MFGridLocation {
        MFGridLocation(h: Int.random(max: columns - 1),
                     v: Int.random(max: rows - 1) )
    }

    /// clamp a gridlocation to grid size

    public func clamp(gridLocation: MFGridLocation) -> MFGridLocation {
        
        MFGridLocation(h: min( max(0, gridLocation.h), columns - 1),
                     v: min( max(0, gridLocation.v), rows - 1))
    }
    
    /// grow a grid on both dimensions by the passed amount
    
    public func grownBy(_ amount: UInt32) -> MFGridSize {
        // we force unwrap because we will never go negative by adding one
       try! MFGridSize(columns: columns + 1, rows: rows + 1 )
    }
}

public extension MFGridSize {
    
    func scanner() -> MFGridScanner {
        MFGridScanner(gridSize: self)
    }
}

public extension CGSize {
    
    var asGridSize: MFGridSize {
        MFGridSize(columns: UInt(abs(width)), rows: UInt(abs(height)))
    }
}
