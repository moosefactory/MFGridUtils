//   /\/\__/\/\      􀮟 MFGridUtils
//   \/\/..\/\/      Efficient grid scanning
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  􀈿 MFCAGridLayer.swift
//  􀓣 Created by Tristan Leblanc on 16/01/2025.

import Foundation
import CoreGraphics
import QuartzCore

/// A subclass of CALayer that holds a MFGrid structure and properly render grid squares.

public class MFCAGridLayer: CALayer {
    
    /// The layer grid.
    public var grid: MFGrid { didSet {
        setNeedsLayout()
    }}
    
    // MARK: - Initialization
    
    /// Init a new layer with a grid.
    /// The layer will have strict dimensions of (gridSize * cellSize) pixels
    public init(grid: MFGrid) {
        self.grid = grid
        super.init()
        self.needsDisplayOnBoundsChange = true
        self.allowsEdgeAntialiasing = false
        frame = grid.frame
    }
    
    /// Init a new layer from a grid layer
    /// This function is needed by the system to manage resizing and animations
    
    override init(layer: Any) {
        if let gridLayer = layer as? MFCAGridLayer {
            grid = gridLayer.grid
        } else {
            fatalError("Why is this layer being created by a random layer?")
        }
        super.init(layer: layer)
    }
    
    /// Init from coder not supported
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Rendering
    
    public override func draw(in ctx: CGContext) {
        grid.render(context: ctx, style: MFGridStyle())
    }
    
}
