//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFGridStyle.swift
//  Created by Tristan Leblanc on 08/01/2025.

import Foundation
import CoreGraphics
import MFFoundation
import AppKit

public struct MFGridStyle {
    
    public init(strokeColor: PlatformColor = .white,
                fillColor: PlatformColor = .white.withAlphaComponent(0.3),
                strokeWidth: CGFloat = 1) {
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.strokeWidth = strokeWidth
    }
    
    var strokeColor: PlatformColor = .white
    var fillColor: PlatformColor = .white
    var strokeWidth: CGFloat = 1
}
