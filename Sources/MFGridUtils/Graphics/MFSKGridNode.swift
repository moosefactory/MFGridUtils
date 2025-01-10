//   /\/\__/\/\      MFGridUtils
//   \/\/..\/\/      Grid scanning made easy
//      (oo)
//  MooseFactory     ©2025 - Moose
//    Software
//  ------------------------------------------
//  MFSKGridNode.swift
//  Created by Tristan Leblanc on 19/12/2024.

import SpriteKit

import MFFoundation

// A Grid Sprite Node to use with SpriteKit
public class MFSKGridNode: SKSpriteNode {
    
    enum Errors: Error {
        case cantCreateTextureBitmap
    }
    
    public var grid: MFGrid

    public var gridStyle = MFGridStyle()
    
    // MARK:  Initialisation
    
    /// Init a grid node using grid and cell sizes
    
    public init(grid: MFGrid) {
        self.grid = grid
        super.init(texture: .none,
                   color: .clear,
                   size: grid.frame.size)
        updateGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.grid = try! MFGrid(gridSize: MFGridSize(size: 100),
                                cellSize: CGSize.square(30),
                                dataLayers: [])
        super.init(coder: aDecoder)
        
        updateGrid()
    }
    
    /// Rebuilds grid sprites

    /// Called when geometry need to be updated
    /// - after a resize
    /// - after grid size or cell size change
    func updateGrid() {
        size = grid.frame.size
        do {
            texture = try makeTexture() { context, size in
                self.grid.render(context: context, style: gridStyle)
            }
        }
        catch {
            print(error)
        }
    }
    
}

public class MFSKDataGridNode<DataType: Equatable>: MFSKGridNode {
    
    /// The data layers to render in the grid node texture
    
    public var dataLayers: [MFGridDataLayer<DataType>]
    
    // MARK: Initialization
    
    /// Initialize a new grid node with the passed data layers
    public init(grid: MFGrid, dataLayers: [MFGridDataLayer<DataType>]) {
        self.dataLayers = dataLayers
        super.init(grid: grid)
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Update
    
    /// Called when geometry need to be updated
    /// - after a resize
    /// - after grid size or cell size change
    
    public override func updateGrid() {
        size = grid.frame.size
        do {
            texture = try makeTexture() { context, size in
                self.grid.render(context: context, style: gridStyle)
                self.dataLayers.first?.renderData(in: context)
            }
        } catch {
            print(error)
        }
    }
}
