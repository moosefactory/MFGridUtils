/*--------------------------------------------------------------------------*/
/*   /\/\/\__/\/\/\        MooseFactory Foundation - Swift - v2.0           */
/*   \/\/\/..\/\/\/                                                         */
/*        |  |             (c)2007-2025 Tristan Leblanc                     */
/*        (oo)                                                              */
/* MooseFactory Software                                                    */
/*--------------------------------------------------------------------------*/
// Bitmap.swift
// Created by Tristan Leblanc on 18/11/2020.

#if !os(watchOS)

import Foundation
import QuartzCore

public struct BitmapUtils {
    
    public enum Errors: String, Error {
        case cantCreateZeroSizeBitmap
        case notEnoughMemoryToCreateBitmap
        // To use when trying to make a bitmap from an NSImage
        case cantMakeCGImageFromNSImage
        // To use when trying to create jpeg data representation
        case cantGenerateJPEGData
    }
    
    public static func createBitMap(size: CGSize) throws -> CGContext {
        guard Int(size.width) >= 1 && Int(size.height) >= 1 else {
            throw Errors.cantCreateZeroSizeBitmap
        }

        let cs = CGColorSpaceCreateDeviceRGB()

        let bitmap = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(size.width), space: cs, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        if bitmap == nil {
            throw Errors.notEnoughMemoryToCreateBitmap
        }
        
        return bitmap!
    }
}

public typealias RawRGBA = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)
public typealias RawScanParameters = (Int, Int)->RawRGBA
public typealias ScanParameters = (CGPoint, inout Any?, CGAffineTransform)->RawRGBA

public extension CGContext {
        
    var size: CGSize {
        CGSize(width: width, height: height)
    }
    
    func rawScan(componentsGenerator: RawScanParameters) {
        for y in 0..<height {
            for x in 0..<width {
                setColorComponents(x: x, y: y, components: componentsGenerator(x,y))
            }
        }
    }
    
    func scan(ctm: CGAffineTransform, userInfo: inout Any?, componentsGenerator: ScanParameters) {
        for y in 0..<height {
            for x in 0..<width {
                let p = CGPoint(x: x, y: y).applying(ctm)
                setColorComponents(x: x, y: y, components: componentsGenerator(p, &userInfo, ctm))
            }
        }
    }

    func colorComponents(x: Int, y: Int) -> (RawRGBA)? {
        guard  0<=x && x<width, 0<=y && y<height else { return nil }
        guard let uncasted_data = self.data else { return nil }
        let data: UnsafeMutablePointer<UInt8> = uncasted_data.assumingMemoryBound(to: UInt8.self)
        let offset = 4 * (y * width + x)
        return RawRGBA(r: data[offset], g: data[offset+1], b: data[offset+2], a: data[offset+3])
    }

    func colorComponents(fractionalX x: CGFloat, fractionalY y: CGFloat) -> (RawRGBA)? {
        guard  0<=x && x<=1, 0<=y && y<=1 else { return nil }
        let x = Int(CGFloat(width) * x)
        let y = Int(CGFloat(height) * y)
        guard let uncasted_data = self.data else { return nil }
        let data: UnsafeMutablePointer<UInt8> = uncasted_data.assumingMemoryBound(to: UInt8.self)
        let offset = 4 * (y * width + x)
        return RawRGBA(r: data[offset], g: data[offset+1], b: data[offset+2], a: data[offset+3])
    }


    func setColorComponents(x: Int, y: Int, components: RawRGBA) {
        guard  0<=x && x<width, 0<=y && y<height else { return }
        guard let uncasted_data = self.data else { return }
        let data: UnsafeMutablePointer<UInt8> = uncasted_data.assumingMemoryBound(to: UInt8.self)
        let offset = 4 * (y * width + x)
        data[offset] = components.r
        data[offset+1] = components.g
        data[offset+2] = components.b
        data[offset+3] = components.a
    }
}

#endif
