//   /\/\__/\/\      􀮟 MFGridUtils
//   \/\/..\/\/      Efficient grid scanning
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  􀈿 MFDataGrid.swift
//  􀓣 Created by Tristan Leblanc on 08/01/2025.

import Foundation
import MFFoundation
import CoreGraphics


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

/// A grid that holds an array of data layers

public class MFDataGrid: MFGrid {
    
    public var dataLayers: [MFGridDataLayerItem]
        
    // MARK: - Initialisation
    
    public init(gridSize:MFGridSize,
                cellSize: CGSize,
                dataLayers: [MFGridDataLayerItem] = []) {
        self.dataLayers =  dataLayers
        super.init(gridSize: gridSize, cellSize: cellSize)
    }
    
    // MARK: - Rendering
    
    override func renderContent(in context: CGContext) {
        dataLayers.forEach { layer in
            layer.dataLayer.renderData(in: context)
        }
    }

}
