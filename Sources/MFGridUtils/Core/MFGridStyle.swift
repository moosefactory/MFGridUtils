//   /\/\__/\/\      􀮟 MFGridUtils
//   \/\/..\/\/      Efficient grid scanning
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  􀈿 MFGridStyle.swift
//  􀓣 Created by Tristan Leblanc on 08/01/2025.

import Foundation
import CoreGraphics
import MFFoundation
#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

public struct MFGridStyle {
    
    public init(strokeColor: PlatformColor = .black,
                fillColor: PlatformColor = .white,
                strokeWidth: CGFloat = 1,
                dash: [CGFloat]? = nil) {
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.strokeWidth = strokeWidth
        self.dash = dash
    }
    
    var strokeColor: PlatformColor = .black
    var fillColor: PlatformColor = .white
    var strokeWidth: CGFloat = 1
    var dash: [CGFloat]?
}
