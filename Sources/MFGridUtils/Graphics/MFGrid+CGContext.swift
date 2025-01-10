//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFGrid+CGContext.swift
//  Created by Tristan Leblanc on 08/01/2025.

import Foundation
import CoreGraphics

import MFFoundation

public extension MFGrid {
    
    func makeContext(gridStyle: MFGridStyle) throws -> CGContext {
        let context = try BitmapUtils.createBitMap(size: frame.size)
        
        render(context: context, style: gridStyle)
        return context
    }
    
    
    func render(context: CGContext,
                style: MFGridStyle) {
        // Lines
        let size = context.size
        
        context.saveGState()
        
        context.clear( CGRect(origin: .zero, size: size) )
        context.setFillColor(style.fillColor.cgColor)
        context.setStrokeColor(style.strokeColor.cgColor)
        
        dataLayers.forEach { layer in
            layer.dataLayer.renderData(in: context)
        }
        
        MFGridScanner(gridSize: gridSize).geometricScanRow(grid: self) { cell in
            context.move(to: cell.locationInFrame)
            context.addLine(to: CGPoint(x: cell.locationInFrame.x, y: size.height))
        }
        
        MFGridScanner(gridSize: gridSize).geometricScanColumn(grid: self) { cell in
            context.move(to: cell.locationInFrame)
            context.addLine(to: CGPoint(x: size.width, y: cell.locationInFrame.y))
        }
        
        context.strokePath()
        
        context.restoreGState()
    }
    
}
