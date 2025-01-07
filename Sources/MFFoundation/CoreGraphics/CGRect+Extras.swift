/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
// CGRect+Extras
// Moofoundation
// Created by Tristan Leblanc on 13/04/2021.

#if !os(watchOS)

import Foundation
import QuartzCore

// MARK: - Rect utilities -

public extension CGRect {
    
    // MARK: - Interesting points utilities
    
    var boundsCenter: CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    var frameCenter: CGPoint {
        return CGPoint(x: minX + size.width / 2, y: minY + size.height / 2)
    }
    
    var halfWidth: CGFloat { return width / 2 }
    var halfHeight: CGFloat { return height / 2 }
    
    
    /// Convenience initializer
    init(minX: CGFloat, minY: CGFloat, maxX: CGFloat, maxY: CGFloat) {
        self.init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    // Mark: - Alignment Utilities
    
    /// Return copy of self, centered on point
    func centered(on point: CGPoint) -> CGRect {
        return CGRect(origin: point - boundsCenter, size: size)
    }

    func centered(in rect: CGRect) -> CGRect {
        if self == rect { return self }
        return self.centered(on: rect.frameCenter)
    }
    
    /// returns rectangle centered on (0,0)
    var zeroCentered: CGRect {
        return centered(on: .zero)
    }
    
    /// Returns a new rectangle, scaled and centered on self
    func centeredScaledRect(scale: CGFloat) -> CGRect {
        return (self * scale).centered(on: frameCenter)
    }
    
    /// Returns integral rect ( integer coordinates )
    var normalize: CGRect {
        return CGRect(x: Int(minX), y: Int(minY), width: Int(width), height: Int(height))
    }
    
    /// Returns copy of self with bottom left at (0,0)
    var atOriginZero: CGRect {
        return CGRect(origin: .zero, size: size)
    }
    
    /// Inset by a fixed value on both axes
    func inset(by d: CGFloat)-> CGRect {
        return insetBy(dx: d, dy: d)
    }
    
    /// Returns a copy of self, scaled up and aligned on nearest grid
    ///
    /// This is usefull to update bitmaps on memory boundaries, for optimized performances.
    ///
    /// Extent is used to grow the clipping rect to take line width in account if needed
    func alignOnGrid(step: CGFloat, extent: CGFloat) -> CGRect {
        return CGRect(minX: step * floor((minX - extent) / step),
                      minY: step * floor((minY - extent) / step),
                      maxX: step * ceil((maxX + extent) / step),
                      maxY: step * ceil((maxY + extent) / step))
    }
    
    /// returns rect of given size, aligned to top left corner
    func topLeftRect(width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: 0, y: self.height - height, width: width, height: height)
    }
    
    /// returns hypthenuse
    var hypo: CGFloat {
        return sqrt( width * width + height * height) / 2
    }
    
    func clipped(to clipRect: CGRect) -> CGRect {
        let miX = max(minX, clipRect.minX)
        let miY = max(minY, clipRect.minY)
        let maX = min(maxX, clipRect.maxX)
        let maY = min(maxY, clipRect.maxY)
        return CGRect(x:miX, y: miY, width: maX - miX, height: maY - miY)
    }
    
    /// returns inset rect, using fractional values
    /// - 0 means no inset
    /// - 1 means inset by half ( which is an empty rect in center )
    func insetByPercent(dx: CGFloat, dy: CGFloat) -> CGRect {
        let dx = halfWidth * dx.clampToPositiveFractional
        let dy = halfHeight * dy.clampToPositiveFractional
        return insetBy(dx: dx, dy: dy)
    }
    
    #if os(macOS)
    
    var ns: NSRect {
        return NSRect(x: minX, y: minY, width: width, height: height)
    }

    #endif
}

// MARK: - Scale to fit / to fill -

public extension CGRect {
    
    /// returns scaled rect fitting in passed rect
    ///
    /// returns the result rect, and the applied scale
    func fit(in rect: CGRect) -> (CGRect, CGFloat) {
        let (fittedSize, scale) = size.fit(in: rect.size)
        let out = CGRect(origin: .zero, size: fittedSize)
        return (out.centered(in: rect), scale)
    }
    
    /// returns scaled rect filling passed rect
    ///
    /// returns the result rect, and the applied scale
    func fill(in rect: CGRect) -> (CGRect, CGFloat) {
        let (fittedSize, scale) = size.fill(in: rect.size)
        let out = CGRect(origin: .zero, size: fittedSize)
        return (out.centered(in: rect), scale)
    }
}

#endif

public extension CGRect {
    
    func divideBy(value: Int) -> CGRect {
        divideBy(value: CGFloat(value))
    }
    
    func divideBy(value: CGFloat) -> CGRect {
        CGRect(x: origin.x, y: origin.y,
               width: size.width / value, height: size.height / value)
    }

    func divideBy(horizontaly: Int = 1, verticaly: Int = 1) -> CGRect {
        divideBy(horizontaly: CGFloat(horizontaly), verticaly: CGFloat(verticaly))
    }
    
    func divideBy(horizontaly: CGFloat = 1, verticaly: CGFloat = 1) -> CGRect {
        CGRect(x: origin.x, y: origin.y,
               width: size.width / horizontaly, height: size.height / verticaly)
    }

    func gridMoveBy(columns: Int, rows: Int) -> CGRect {
        gridMoveBy(columns: CGFloat(columns), rows: CGFloat(rows))
    }
    
    func gridMoveBy(columns: Double, rows: Double) -> CGRect {
        offsetBy(dx: columns * size.width, dy: rows * size.height)
    }
}
