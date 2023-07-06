/*********************************************************************************
 * Falling Blocks
 *
 * Copyright 2023, Jonathan Nobels
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 **********************************************************************************/


import Foundation
import SwiftUI

class Renderer {
    /// Returns the bounding box for a cell on the gameboard in the given location, with
    /// the given insets
    func rectFor(location: Location,
                 gridSize: Size,
                 canvasSize: CGSize,
                 inset: CGFloat = 1,
                 canvasInset: CGFloat = 0) -> CGRect {
        let cellWidth = (canvasSize.width - 2.0 * canvasInset) / CGFloat(gridSize.width)
        let cellHeight = (canvasSize.height - 2.0 * canvasInset) / CGFloat(gridSize.height)
        
        return CGRectMake(canvasInset + CGFloat(location.col) * cellWidth + inset * 0.5,
                          canvasInset + (CGFloat(location.row) * cellHeight + inset * 0.5),
                          cellWidth - inset,
                          cellHeight - inset)
    }
    
    func drawCellFilled(cell: Cell, inContext context: inout GraphicsContext, inRect rect: CGRect) {
        let path = Path(roundedRect: rect, cornerSize: CGSizeMake(2.0,2.0))
        context.fill(path, with: .color(cell.color.opacity(cell.opacity)))
    }
    
    func drawCellEmpty(cell: Cell, inContext context: inout GraphicsContext, inRect rect: CGRect) {
        let path = Path(rect)
        context.stroke(path, with: .color(red: 0.2, green: 0.2, blue: 0.2), style: StrokeStyle(lineWidth: 0.5))
    }
}

/// Renders the piece preview
class PieceRenderer: Renderer {
    let gridSize = Size(width:4, height: 2)
    
    func render(piece: Piece?, context: inout GraphicsContext, size: CGSize) {
        guard let piece = piece else {
            return
        }
        
        piece.orientation = piece.previewOrientation
        
        for rowIndex in 0..<piece.size().height {
            let row = piece.rows()[rowIndex]
            for colIndex in 0..<(row.cells.count){
                let cell = row.cells[colIndex]
                let cellLoc = Location(col: colIndex, row: rowIndex)
                let rect = rectFor(
                    location: cellLoc,
                    gridSize: gridSize,
                    canvasSize: size)
                if cell.occupied {
                    drawCellFilled(cell: cell, inContext: &context, inRect: rect)
                }
            }
        }
    }
}

/// Renders the gameboard
class BoardRenderer: Renderer {
    
    func render(board: Board, context: inout GraphicsContext, size: CGSize) {
        let frame = CGRect(origin: CGPoint(x: 0,y: 0), size: size)
        let path = Path(roundedRect: frame, cornerSize: CGSizeMake(2.0,2.0))
        context.fill(path, with: .color(.black))
        context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: 4.5))
        
        for rowIndex in 0..<board.size.height {
            let row = board.rows[rowIndex]
            for colIndex in 0..<(row.cells.count){
                let cell = row.cells[colIndex]
                let cellLoc = Location(col: colIndex, row: rowIndex)
                let rect = rectFor(
                    location: cellLoc,
                    gridSize: board.size,
                    canvasSize: size,
                    inset: 1.0,
                    canvasInset: 4.0)
                if cell.occupied {
                    drawCellFilled(cell: cell, inContext: &context, inRect: rect)
                } else {
                    drawCellEmpty(cell: cell, inContext: &context, inRect: rect)
                }
            }
        }
    }
    

}
