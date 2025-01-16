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
        
        // Renders the background
        context.addRect(frame)
        context.fillPath()
        
        // Do some extra renderings before drawing the lines
        renderContent(in: context)
        
        // Draw the horizontal and vertical grid lines
        scanner().scanRow { scanner in
            if let cellFrame = scanner.cell.frame {
                context.move(to: cellFrame.origin)
                context.addLine(to: CGPoint(x: cellFrame.minX, y: size.height))
            }
        }

        scanner().scanColumn { scanner in
            if let cellFrame = scanner.cell.frame {
                context.move(to: cellFrame.origin)
                context.addLine(to: CGPoint(x: size.width, y: cellFrame.height))
            }
        }
        
        context.strokePath()
        
        context.restoreGState()
    }
    
}
