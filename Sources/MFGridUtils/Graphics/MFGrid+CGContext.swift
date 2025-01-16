//   /\/\__/\/\      􀮟 MFGridUtils
//   \/\/..\/\/      Efficient grid scanning
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  􀈿 MFGrid+CGContext.swift
//  􀓣 Created by Tristan Leblanc on 08/01/2025.

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
        let size = frame.size
        
        context.saveGState()
        
        context.clear( CGRect(origin: .zero, size: frame.size) )
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
                print(cellFrame)
                context.move(to: CGPoint(x: cellFrame.origin.x, y: 0))
                context.addLine(to: CGPoint(x: cellFrame.origin.x, y: size.height))
            }
        }
        // Draw the last vertical line
        context.move(to: CGPoint(x: size.width, y: 0))
        context.addLine(to: CGPoint(x: size.width, y: size.height))

        scanner().scanColumn { scanner in
            if let cellFrame = scanner.cell.frame {
                print(cellFrame)

                context.move(to: CGPoint(x: 0, y: cellFrame.origin.y))
                context.addLine(to: CGPoint(x: size.width, y: cellFrame.origin.y))
            }
        }
        // Draw the last horizontal line
        context.move(to: CGPoint(x: 0, y: size.height))
        context.addLine(to: CGPoint(x: size.width, y: size.height))

        context.strokePath()
        
        context.restoreGState()
    }
    
}
