//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFGridDataLayer.swift
//  Created by Tristan Leblanc on 07/01/2025.

import Foundation
import MFFoundation
import CoreGraphics


public typealias MFGridLocationClosure = (MFGridLocation) -> Void
public typealias MFGridIndexedLocationClosure = (Int, MFGridLocation) -> Void
public typealias MFGridScanClosure = (MFGridCell) -> Void
public typealias MFGridGeoScanClosure = (MFGeoGridCell) -> Void
public typealias MFGridGeoScanIndexedClosure = (Int,MFGeoGridCell) -> Void

public typealias MFGridProcessorClosure<T> = (Int, MFGridLocation) -> T
public typealias MFGeoGridProcessorClosure<T> = (Int, MFGridCell) -> T

/// The closure used to scan grid
///
/// It passes the grid cell and a value
/// It returns a value

public typealias MFDataGridGeoScanClosure<CellDataType> = (MFGridCell, CellDataType?) -> CellDataType?

/// MFGridDataLayer stores data by [column, raw]

public class MFGridDataLayer<CellDataType>: DataLayerProtocol {
    
    public init(grid: MFGrid,
                allocator: @escaping(MFGridCell)->CellDataType?,
                cellRenderer: @escaping (MFGridCell, CGContext, CellDataType)->Void) {
        self.grid = grid
        self.allocator = allocator
        self.cellRenderer = cellRenderer
        grid.scan { cell in
            self.cellData[cell.key] = allocator(cell)
        }
    }
    
    // A weak reference to the owner grid
    
    weak var grid: MFGrid?
        
    let allocator: (MFGridCell)->CellDataType?
    let cellRenderer: (MFGridCell, CGContext, CellDataType)->Void
    
    /// cellData are stored in a dictionary
    var cellData = [MFGridLocationKey:CellDataType]()

    /// Store data
    
    public func write(data: CellDataType,
                      at gridLoc: MFGridLocation) {
        cellData[gridLoc.asKey] = data
    }
    
    /// Retrieve data in the grid
    
    public func data(initializeCellsIfNeeded: Bool,
                     for gridCell: MFGridCell)-> CellDataType? {
        let data: CellDataType? = cellData[gridCell.key]
        if data != nil && initializeCellsIfNeeded {
            if let data = allocator(gridCell) {
                cellData[gridCell.key] = data
            }
        }
        return data
    }
    
    /// Scan the grid

    public func scan(intializeCellsIfNeeded: Bool,
                     cellSize: CGSize,
                     closure: @escaping MFDataGridGeoScanClosure<CellDataType>) {
        grid?.scan() { cell in
            let data = self.data(initializeCellsIfNeeded: intializeCellsIfNeeded,
                                 for: cell)
            
            if let newData = closure(cell, data) {
                self.write(data: newData, at: cell.gridLocation)
            }
        }
    }
    
    public func renderData(in context: CGContext) {
        guard let grid = grid else { return }
        scan(intializeCellsIfNeeded: false,
             cellSize: grid.cellSize) { cell, data in
            if let data: CellDataType = self.data(initializeCellsIfNeeded: false, for: cell) {
                self.cellRenderer(cell, context, data)
            }
            return data
        }
    }
}
