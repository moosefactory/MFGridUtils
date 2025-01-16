//   /\/\__/\/\      􀮟 MFGridUtils
//   \/\/..\/\/      Efficient grid scanning
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  􀈿 MFGrid.swift
//  􀓣 Created by Tristan Leblanc on 08/01/2025.

import MFFoundation
import CoreGraphics

/// MFGrid
///
/// The top level object of this framework
///
/// Everything to create a grid object and associate data is here in one place

public class MFGrid {
    
    var sizeDidChange: ((MFGrid, MFGridSize)->Void)?
    
    public var gridSize: MFGridSize { didSet {
        sizeDidChange?(self, oldValue)
    }}
    
    public var cellSize: CGSize
    
    public struct GridRect {
        var origin: MFGridLocation = .zero
        var size: MFGridSize = .zero
    }

    // MARK: - Initialisation
    
    
    /// Initializes a grid of the given size
    /// An optional cellSize can be set if a geometric representation is needed
    /// - Parameters:
    ///   - gridSize: The size of the grid ( columns x rows )
    ///   - cellSize: An optional grid cell size
    public init(gridSize:MFGridSize,
                cellSize: CGSize = .zero,
                sizeDidChange: ((MFGrid, MFGridSize)->Void)? = nil) {
        self.gridSize = gridSize
        self.cellSize = cellSize
        self.sizeDidChange = sizeDidChange
    }
    
    /// Returns the grid frame expressed in columns and rows
    public var gridRect: MFGridRect { MFGridRect(origin: .zero, size: gridSize) }
    
    /// Returns the grid frame if the grid cell is set
    public var frame: CGRect { gridSize.frame(for: cellSize) }

    // TODO: Move in GridRenderer
    func renderContent(in context: CGContext) {
        
    }
}

// MARK: - Scan

extension MFGrid {
    
    // Proceed to a simple geometric scan over the grid
    public func scan(_ closure: @escaping MFGridScannerClosure) {
        scanner().cellScan() { scanner in
            closure(scanner)
        }
    }


    /// Converts cell index to grid location
    ///
    /// Returns nil if the index is out of grid

    public func location(at index: Int) -> MFGridLocation? {
        guard index >= 0, index < gridSize.numberOfCells else {
            return nil
        }
        return MFGridLocation(h: index / gridSize.columns,
                              v: index % gridSize.columns)
    }
}

// MARK: - Geometry Extension

extension MFGrid {
    
    /// Returns the rectangle in node coordinate of the cell at passed location in grid (column, row)
    /// - Parameter cell: the cell we want to know the frame
    /// - Returns: The CGRect frame of the cell
    
    public func rect(for cell: MFGridCell) -> CGRect {
        rectForCell(at: cell.gridLocation)
    }
    
    /// Returns the frame of the cell at given location, in grid frame coordinates.
    /// - Parameter gridLocation: The grid locationwe want to know the frame
    /// - Returns: The CGRect frame of the cell at given location, if the cell size is known

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
    
    public func location(for gridLocation: MFGridLocation) -> CGPoint? {
        let gridLoc = gridLocation.asCGFloats
        return CGPoint(x: gridLoc.h * cellSize.width,
                              y: gridLoc.v * cellSize.height)
    }
}

extension MFGrid: CustomStringConvertible {
    
    public var description: String {
        "􀮟 Grid \(gridSize) - Cell: \(cellSize.dec3) - \(frame.dec3)"
    }
}
