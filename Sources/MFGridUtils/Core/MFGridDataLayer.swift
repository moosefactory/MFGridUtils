//   /\/\__/\/\      􀮟 MFGridUtils
//   \/\/..\/\/      Efficient grid scanning
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFGridDataLayer.swift
//  􀓣 Created by Tristan Leblanc on 07/01/2025.

import Foundation
import MFFoundation
import CoreGraphics

//public typealias MFGridLocationClosure = (MFGridLocation) -> Void
//public typealias MFGridIndexedLocationClosure = (Int, MFGridLocation) -> Void
//public typealias MFGridScanClosure = (MFGridCell) -> Void

//public typealias MFGridGeoScanClosure = (MFGeoGridCell) -> Void
//public typealias MFGridGeoScanIndexedClosure = (Int,MFGeoGridCell) -> Void
//
//public typealias MFGridProcessorClosure<T> = (Int, MFGridLocation) -> T
//public typealias MFGeoGridProcessorClosure<T> = (Int, MFGridCell) -> T

/// The closure used to scan grid
///
/// It passes the grid cell and a value
/// It returns a value
//public typealias MFGridScannerClosure = (MFGridScanner)->Void

public typealias MFDataGridScannerClosure<CellDataType> = (MFGridScanner, CellDataType?) -> Void
public typealias MFDataGridProcessorClosure<CellDataType> = (MFGridScanner, CellDataType?) -> CellDataType?

/// MFGridDataLayer stores data by [column, raw]

public class MFGridDataLayer<CellDataType>: DataLayerProtocol {
    
    public init(grid: MFGrid,
                allocator: @escaping(MFGridScanner)->CellDataType?,
                cellRenderer: @escaping (MFGridScanner, CGContext, CellDataType)->Void) {
        self.grid = grid
        self.allocator = allocator
        self.cellRenderer = cellRenderer
        grid.scan { scanner in
            self.cellData[scanner.cell.key] = allocator(scanner)
        }
    }
    
    // A weak reference to the owner grid
    
    weak var grid: MFGrid?
        
    let allocator: (MFGridScanner)->CellDataType?
    let cellRenderer: (MFGridScanner, CGContext, CellDataType)->Void
    
    /// cellData are stored in a dictionary
    var cellData = [MFGridLocation:CellDataType]()

    /// Store data
    
    public func write(data: CellDataType,
                      at gridLoc: MFGridLocation) {
        cellData[gridLoc] = data
    }
    
    /// Retrieve data in the grid
    
    public func data(initializeCellsIfNeeded: Bool,
                     for gridScanner: MFGridScanner)-> CellDataType? {
        
        let data: CellDataType? = cellData[gridScanner.cell.key]
        
        if data != nil && initializeCellsIfNeeded {
            if let data = allocator(gridScanner) {
                cellData[gridScanner.cell.key] = data
            }
        }
        return data
    }
    
    /// Scan the grid

    public func process(intializeCellsIfNeeded: Bool,
                     cellSize: CGSize,
                     closure: @escaping MFDataGridProcessorClosure<CellDataType>) {
        guard let grid = grid else { return }

        grid.scan() { scanner in
            let data = self.data(initializeCellsIfNeeded: intializeCellsIfNeeded,
                                 for: scanner)
            
            if let newData = closure(scanner, data) {
                self.write(data: newData, at: scanner.cell.gridLocation)
            }
        }
    }
    
    // MARK: - Rendering
    
    public func renderData(in context: CGContext) {
        guard let grid = grid else { return }
        process(intializeCellsIfNeeded: false,
             cellSize: grid.cellSize) { scanner, data in
            if let data: CellDataType = self.data(initializeCellsIfNeeded: false, for: scanner) {
                self.cellRenderer(scanner, context, data)
            }
            return data
        }
    }
    
    
}
