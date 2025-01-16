import Testing
@testable import MFGridUtils
import CoreGraphics

@Test func testDataLayerDictionaryData() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    
    struct CellData {
        internal init(_ value: Int = 1972) {
            self.value = value
        }
        
        var value: Int = 1972
    }
    
    class DataLayer: MFGridDataLayer<CellData> {
        
    }
    
    let gridSize = try MFGridSize(size: 1000)
    let cellSize = CGSize.square(10)
    let grid = MFGrid(gridSize: gridSize, cellSize: cellSize)
    
    let dataLayer = DataLayer(grid: grid) { cell in
        return CellData()
    } cellRenderer: { cell, context, cellData in
        
    }
    
    for i in 0..<5000 {
        if let loc = grid.location(at: i) {
            dataLayer.write(data: CellData(i), at: loc)
        }
    }
}

@Test func testGridSize() async throws {
    
    let gridSize = MFGridSize(size: 10)
    
}
