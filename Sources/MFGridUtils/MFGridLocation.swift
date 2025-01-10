//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  GridLocation.swift
//  Created by Tristan Leblanc on 22/12/2024.

import Foundation
import CoreGraphics

/// A location in grid coordinates

public struct MFGridLocation {
    
    public static let zero = MFGridLocation(h: 0, v: 0)
    
    public var h: Int = 0
    public var v: Int = 0
    
    public var column: Int { h }
    public var row: Int { v }
    
    public init(h: Int = 1, v: Int = 1) {
        self.h = h
        self.v = v
    }
    
    /// Returns the location converted to [0.0,1.0] range for a given grid size
    
    public func fractionalLocation(for gridSize: MFGridSize) -> CGPoint {
        return CGPoint(x: CGFloat(h) / CGFloat(gridSize.columns),
                       y: CGFloat(v) / CGFloat(gridSize.rows))
    }
    
    /// Converts to point in grid frame
    
    public func toPoint(for cellSize: CGSize) -> CGPoint {
        return CGPoint(x: CGFloat(h) * cellSize.width,
                       y: CGFloat(v) * cellSize.height)
    }
    
    /// Converts point in grid frame for given cell size
    
    public func fromPoint(_ point: CGPoint, for cellSize: CGSize) -> MFGridLocation {
        return MFGridLocation(h: Int(cellSize.width / point.x),
                              v: Int(cellSize.height / point.y))
    }
    
    /// Converts to rect in grid frame
    
    public func frame(for cellSize: CGSize) -> CGRect {
        return CGRect( origin: CGPoint(x: CGFloat(h) * cellSize.width,
                                       y: CGFloat(v) * cellSize.height),
                       size: cellSize)
    }
}

// MARK: - Convenience accessors

extension MFGridLocation {
    
    @inlinable public var asCInts: (h: CInt, v:CInt) {
        (h: CInt(h), v: CInt(v))
    }
    
    @inlinable public var asCFloats: (h: CFloat, v:CFloat) {
        (h: CFloat(h), v: CFloat(v))
    }
    
    @inlinable public var asCGFloats: (h: CGFloat, v:CGFloat) {
        (h: CGFloat(h), v: CGFloat(v))
    }
    
    @inlinable public var asCGPoint: CGPoint {
        CGPoint(x: h, y: v)
    }
    
}

extension MFGridLocation: Equatable {
    
    public static func == (lhs: MFGridLocation, rhs: MFGridLocation) -> Bool {
        return lhs.h == rhs.h && lhs.v == rhs.v
    }
}

public extension CGPoint {
    
    func toGridlocation(cellSize: CGSize) -> MFGridLocation {
        MFGridLocation(h: Int(x / cellSize.width), v: Int(y / cellSize.height))
    }
}

extension MFGridLocation: CustomStringConvertible {
    
    /// Returns the debug description
    
    public var description: String {
        return "[col:\(column);row:\(row)]"
    }
}