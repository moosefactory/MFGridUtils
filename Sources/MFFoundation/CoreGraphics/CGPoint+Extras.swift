/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
// CGPoint+Extras
// Created by Tristan Leblanc on 13/04/2021.

#if !os(watchOS)

import Foundation
import QuartzCore

// MARK: Fractional conversions

public extension CGPoint {
    /// Returns a point in positive fractional format
    /// (0,0) is bottom left corner
    /// (1,1) is top right corner
    func toPositiveFractional(in rect: CGRect) -> CGPoint {
        return CGPoint(x: (x - rect.minX) / rect.width, y: (y - rect.minY) / rect.height)
    }

    func fromPositiveFractional(in rect: CGRect) -> CGPoint {
        return CGPoint(x: x * rect.width + rect.minX, y: y * rect.height + rect.minY)
    }

    /// Returns a point in fractional format
    /// (0,0) is center
    /// (1,1) is top right corner
    /// (-1,-1) is bottom left corner
    func toFractional(in rect: CGRect) -> CGPoint {
        return CGPoint(x: (x - rect.frameCenter.x) / (rect.width / 2), y: (y - rect.frameCenter.y) / (rect.height / 2))
    }

    func fromFractional(in rect: CGRect) -> CGPoint {
        return CGPoint(x: (x * rect.width / 2) + rect.frameCenter.x, y: (y * rect.height / 2) + rect.frameCenter.y)
    }
    
    func clampToFractional() -> CGPoint {
        return CGPoint(x: x.clampToFractional, y: y.clampToFractional)
    }
    
    func clampToPositiveFractional() -> CGPoint {
        return CGPoint(x: x.clampToPositiveFractional, y: y.clampToPositiveFractional)
    }
    
    func scaledBy(size: CGSize) -> CGPoint {
        return CGPoint(x: x * size.width,
                       y: y * size.height)
    }
}

// MARK: - CGPoint/NSNumbers conversions

public extension CGPoint {
    
    /// Converts to size
    var toSize: CGSize { return CGSize(width: x, height: y)}

    /// returns coordinates as numbers
    var asNumbers: (NSNumber, NSNumber) {
        return (NSNumber(value: Double(x)), NSNumber(value: Double(y)))
    }
}

// MARK: - Create Rects centered on point
public extension CGPoint {

    /// Returns a rect of given size, centered on self
    func centeredRect(size: CGSize) -> CGRect {
        return CGRect(x: x - size.width / 2, y: y - size.height / 2, width: size.width, height: size.height)
    }
    
    /// Returns a rect containing a circle of given ray, centered on self
    func centeredRect(ray: CGFloat) -> CGRect {
        return CGRect(x: x - ray, y: y - ray, width: ray * 2, height: ray * 2)
    }
}

public extension CGPoint {
    func with(x: CGFloat) -> CGPoint { CGPoint(x: x, y: self.y) }
    func with(y: CGFloat) -> CGPoint { CGPoint(x: self.x, y: y) }
}

#endif
