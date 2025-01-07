/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
//  Image+Extras.swift
//  Created by Tristan Leblanc on 07/12/2020.

#if !os(watchOS)

import Foundation
import QuartzCore

#if os(macOS)
import Cocoa
public typealias PlatformImage = NSImage
public typealias PlatformColor = NSColor
public typealias PlatformFont = NSFont
#else
import UIKit
public typealias PlatformImage = UIImage
public typealias PlatformColor = UIColor
public typealias PlatformFont = UIFont

public extension UIImage {
    
    func cgImage() throws -> CGImage {
        guard let cgImage = cgImage else {
            throw(NSError())
        }
        return cgImage
    }
}
#endif

// MARK: - Images

public extension PlatformImage {
    
    func bitmap() throws -> CGContext  {
        let bitmap = try BitmapUtils.createBitMap(size: size)
        let cg = try cgImage()
        let rect = bounds
        bitmap.draw(cg, in: rect, byTiling: false)
        return bitmap
    }
    
    var bounds: CGRect {
        return CGRect(origin: .zero, size: size)
    }
}

public extension CGImage {

    var size: CGSize {
        return CGSize(width: width, height: height)
    }
}

#if os(macOS)

public extension CGImage {
    
    var nsImage: NSImage {
        return NSImage(cgImage: self, size: size)
    }
}

public extension NSImage {

    func cgImage() throws -> CGImage {
        var rect = bounds
        guard let cgImage = self.cgImage(forProposedRect: &rect, context: nil, hints: nil) else {
            throw BitmapUtils.Errors.cantMakeCGImageFromNSImage
        }
        return cgImage
    }
    
    func jpegData(quality: CGFloat = 0.5) throws -> Data {
        let cg = try cgImage()
        let bitmapRep = NSBitmapImageRep(cgImage: cg)
        guard let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg,
                                                      properties: [NSBitmapImageRep.PropertyKey.compressionFactor :  NSNumber(value: Double(quality))]) else {
                                                        throw BitmapUtils.Errors.cantGenerateJPEGData
        }
        return jpegData
    }
}

#endif

#endif // watch
