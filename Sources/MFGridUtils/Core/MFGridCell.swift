//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  GridCell.swift
//  Created by Tristan Leblanc on 08/01/2025.

import Foundation


public protocol MFGridCellProtocol {
    var gridLocation: MFGridLocation {get set}
}

public extension MFGridCellProtocol {
    
    // A string key to store locations in dictionaries
    
    var key: MFGridLocationKey { gridLocation.asKey }

    func fractionalLocation(for gridSize: MFGridSize) -> CGPoint {
        gridLocation.fractionalLocation(for: gridSize)
    }
    
    func frame(for cellSize: CGSize) -> CGRect {
        gridLocation.frame(for: cellSize)
    }
}

/// The class that is passed for geometric or rendering operationss
///
/// The principle of the cell is to be create once and modified during the loops.

public class MFGridCell {
    public var gridLocation: MFGridLocation
    
    public var key: MFGridLocationKey { gridLocation.asKey }
    
    public init(gridLocation: MFGridLocation) {
        self.gridLocation = gridLocation
    }
}

public class MFGeoGridCell: MFGridCell {
        
    public var cellSize: CGSize

    public init(gridLocation: MFGridLocation,
                cellSize: CGSize) {
        self.cellSize = cellSize
        super.init(gridLocation: gridLocation)
    }

    public init(gridLocation: MFGridLocation,
                grid: MFGrid) {
        self.grid = grid
        self.cellSize = grid.cellSize
        super.init(gridLocation: gridLocation)
    }

    public var locationInFrame: CGPoint { gridLocation.toPoint(for: cellSize) }
    
    public var frame: CGRect { gridLocation.frame(for: cellSize) }

    // An optional grid object that can be passed to the cell
    public var grid: MFGrid? = nil

    // Return direct neighbouring cells
    
    public var neighboursLocations: [MFGridLocation] {
        let h = gridLocation.h
        let v = gridLocation.v
        
        let offsets = [
            (-1,-1), (0,-1), (1,-1),
            (-1,0), (1,0),
            (-1,1), (0,1), (1,1),
        ]
        
        return offsets.map { offset in
            MFGridLocation(h: h + offset.0, v: v + offset.1)
        }
    }
    
}
