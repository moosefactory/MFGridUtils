//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFSKGridTexture.swift
//  Created by Tristan Leblanc on 07/01/2025.

import Foundation
import SpriteKit
import MFFoundation

public extension MFSKGridNode {
        
    /// Creates the texture by calling the grid render block
    
    func makeTexture(renderBlock: (CGContext, CGSize)->Void) throws -> SKTexture {
        
        let bitmap = try BitmapUtils.createBitMap(size: grid.frame.size)
        renderBlock(bitmap, grid.cellSize)
        guard let textureImage = bitmap.makeImage() else {
            throw(Errors.cantCreateTextureBitmap)
        }
        return SKTexture(cgImage: textureImage)
    }

}

