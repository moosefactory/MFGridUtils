//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFGrid.swift
//  Created by Tristan Leblanc on 08/01/2025.

import Foundation
import MFFoundation
import CoreGraphics

/// MFGrid
///
/// The top level object of this framework
///
/// Everything to create a grid object and associate data is here in one place

public protocol DataLayerProtocol: Any {
    func renderData(in context: CGContext)
}

public struct MFGridDataLayerItem {
    public init(dataLayer: DataLayerProtocol, type: AnyObject.Type) {
        self.dataLayer = dataLayer
        self.type = type
    }
    
    public var dataLayer: DataLayerProtocol
    public var type: AnyObject.Type
}

public class MFGrid {
    
    public var gridSize: MFGridSize
    public var cellSize: CGSize
    public var dataLayers: [MFGridDataLayerItem]
    
    public var frame: CGRect { gridSize.frame(for: cellSize) }
    
    // MARK: - Initialisation
    
    public init(gridSize:MFGridSize,
                cellSize: CGSize,
                dataLayers: [MFGridDataLayerItem] = []) {
        self.gridSize = gridSize
        self.cellSize = cellSize
        self.dataLayers =  dataLayers
    }
    
    public func location(at index: Int) -> MFGridLocation? {
        guard index >= 0, index < gridSize.numberOfCells else {
            return nil
        }
        let col = index % gridSize.columns
        let row = index / gridSize.columns
        
        return MFGridLocation(h: col, v: row)
    }
    
    // Proceed to a simple geometric scan over the grid
    func scan(_ closure: @escaping MFGridGeoScanClosure) {
        MFGridScanner(grid: self).geometricScan(cellSize: cellSize) { cell in
            closure(cell)
        }
    }
}

// MARK: - Geometry Extension

extension MFGrid {
    
    /// Returns the rectangle in node coordinate of the cell at passed location in grid (column, row)
    
    public func rect(for cell: MFGridCell) -> CGRect {
        rectForCell(at: cell.gridLocation)
    }
    
    // Returns the frame of the cell at given location, in grid frame coordinates.
    
    public func rectForCell(at gridLocation: MFGridLocation) -> CGRect {
        let location = gridLocation.toPoint(for: cellSize)
        let offset = frame.boundsCenter
        return CGRect(origin: location, size: cellSize)
            .offsetBy(dx: -offset.x, dy: -offset.y)
    }
    
    // Returns a GridCell object describing the cell at given location.
    
    public func cell(at location: MFGridLocation, offset: (Int, Int) = (0,0)) -> MFGridCell {
        let gridLocation = MFGridLocation(h: location.h + offset.0,
                                          v: location.v + offset.1)
        return MFGeoGridCell(gridLocation: gridLocation, grid: self)
    }
    
    /// returns the grid location (column, row) for a given location in (pixels) in grid frame
    
    public func gridLocation(for locationInFrame: CGPoint) -> MFGridLocation? {
        guard frame.contains(locationInFrame) else { return nil }
        let gridSize = gridSize.asCGFloat
        return MFGridLocation(h: Int((locationInFrame.x / frame.size.width) * gridSize.columns),
                              v: Int((locationInFrame.y / frame.size.height) * gridSize.rows))
    }
    
}
