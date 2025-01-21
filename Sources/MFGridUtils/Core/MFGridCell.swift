//   /\/\__/\/\      􀮟 MFGridUtils
//   \/\/..\/\/      Efficient grid scanning
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  GridCell.swift
//  􀓣 Created by Tristan Leblanc on 08/01/2025.

import Foundation


public protocol MFGridCellProtocol {
    var gridLocation: MFGridLocation { get set }
}

public protocol MFGeoGridCellProtocol: MFGridCellProtocol {
    var cellSize: CGSize { get }
    var frame: CGRect { get }
}


public class MFGridCell: MFGridCellProtocol {
    public var gridLocation: MFGridLocation
    
    public init(gridLocation: MFGridLocation) {
        self.gridLocation = gridLocation
    }
}

public class MFGeoGridCell: MFGridCell, MFGeoGridCellProtocol {
    
    public var cellSize: CGSize { grid.cellSize }
    
    
    public var grid: MFGrid

    public init(gridLocation: MFGridLocation, grid: MFGrid) {
        self.grid = grid
        super.init(gridLocation: gridLocation)
    }

    public var location: CGPoint {
        gridLocation.toPoint(for: cellSize)
    }
    
    public var fractionalLocation: CGPoint {
        gridLocation.fractionalLocation(for: grid.gridSize)
    }

    public var frame: CGRect { gridLocation.frame(for: cellSize) }
}
