# MFGridUtils
*Grid scanning made easy*

![MFGridUtils logo](Icon_128.png)

A simple **Foundation** and **CoreGraphics** extension to execute operations on grids.

## Description

**Grids are 2 dimensions arrays with a minimal size of 1.**

Principal types are the following :

### GridSize

A grid size, in columns and rows


### GridLocation

A location in a grid, given column an row

```
// Makes a 10 x 10 grid
let gridSize = MFGridSize(10)

MFGridScanner(with: gridSize).scan { scanner in
    print("Cell at index \(scanner.index) - location: \(scanner.location)")
}

Results:
Cell at index 0 - location: [col:0;row:0]
Cell at index 1 - location: [col:1;row:0]
Cell at index 2 - location: [col:2;row:0]
...
Cell at index 99 - location: [col:9;row:9]

```

### GridCell

A grid cell, containing location in grid and rect in frame


![MFGridUtils Scheme](MFGridUtilsScheme.png)

## Classes

### MFGridUtils

The main library file

### MFGridLocation

Defines a location in grid, with column and row

### MFSKGridNode

A grid node for SpriteKit

### MFGridScanner

Iterate through grid cells

### MFGridSize

Defines grid dimensions in columns and rows

--

*©2024 Moose Factory Software*
