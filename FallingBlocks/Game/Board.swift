//
//  Board.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-02.
//

import Foundation
import SwiftUI

typealias Location = (col: Int, row: Int)


enum OverlayType {
    case add
    case remove
    case test
}

extension Board: Animator {
    func animate() {
        rows.forEach { row in
            row.animation?.runAnimation()
        }
    }
}


/// Our board represents the Tetr... err... Falling Blocks board.
/// The typical size is 10x20 though it's arbitrary here
class Board {
    let size = Size(10, 20)
    
    // A board is componsed of an array of rows.  It is not strictly
    // neccessary for all of these to have the same length but you
    // probably want them to
    var rows: [Row] = []
    
    // This is the currently active piece in play.  nil if there is
    // no piece in play.  Pieces track their location in board space
    var activePiece: Piece?
    
    init() {
        reset()
    }
    
    // Resets all the cells on the board to the empty cell.
    func reset() {
        rows = []
        for rowIdx in 0..<size.height {
            let row = Row.emptyRow(size.width, index: rowIdx)
            rows.append(row)
        }
        activePiece = nil
    }
    
    /// Adds a new active piece at it's currently assigned location.
    /// Returns false if the piece interferes - which indicates that
    /// it's game over man.  The active piece is always overlayed onto
    /// the board and included in the array of rows so simply rendering
    /// the rows will also render the piece.
    func addActivePiece(_ piece: Piece) -> Bool {
        activePiece = piece
        return overlayPiece(piece, operation: .test)
    }
    
    /// Rotates the active piece in the given direction - if possible
    /// Returns true of the piece was rotated - though we don't really
    /// care about failed rotations
    @discardableResult
    func rotateActivePiece(_ direction:Rotation) -> Bool {
        guard let piece = activePiece else {
            return true
        }
        
        // First, remove the piece from the board
        overlayPiece(piece, operation: .remove)
        
        // Keep track of it's current orientation
        let currentOrientation = piece.orientation
        
        // Rotate the piece and check for any interference
        piece.rotate(direction)
        let rotated = overlayPiece(piece, operation: .test)
        if !rotated {
            piece.orientation = currentOrientation
        }
        
        // Add the piece back to the board
        overlayPiece(piece, operation: .add)
        
        return rotated
    }
    
    /// Moves the active piece by one square.  Returns true if the piece
    /// did move.  Failure to move a piced in the .down direction is an indication
    /// that the board should be checked and a new active piece should be spawned.
    @discardableResult
    func moveActivePiece(_ type: Movement) -> Bool {
        guard let piece = activePiece else {
            return true
        }
        
        // Revmove the piece from the board.  We're going to move it to it's new
        // location and that probably interferes with it's old location
        overlayPiece(piece, operation: .remove)
        
        // Keep track of where the piece was, and where we want it to go
        let currentLocation = piece.location
        let newLocation: Location
        
        switch type {
        case .down:
            newLocation = Location(col: currentLocation.col, row: currentLocation.row + 1)
        case .right:
            newLocation = Location(col: currentLocation.col + 1, row: currentLocation.row)
        case .left:
            newLocation = Location(col: currentLocation.col - 1, row: currentLocation.row)
        }
        
        // Put the piece in the location it would be if the move is legal
        piece.location = newLocation
        
        // Test that the move is legal
        let canMove = overlayPiece(piece, operation: .test)
        
        // If not legal, put th piece back where it was
        if !canMove {
            piece.location = currentLocation
        }
        
        // Overlay the piece back onto the board
        overlayPiece(piece, operation: .add)

        return canMove
    }
    
    
    /// Overlays the piece onto the gameboard at the given location
    /// Returns true if the piece can be overlayed without interfering
    /// with any currently occupied cells
    ///
    /// The Overlay type specifies whether we should fill the cells of the
    /// board, empty them, or simply test
    @discardableResult
    func overlayPiece(_ piece: Piece, operation: OverlayType) -> Bool {
        
        var canMove = true
        
        for pieceRowIdx in 0..<piece.rows().count {
            let row = piece.rows()[pieceRowIdx]
            
            let boardRow = piece.location.row + pieceRowIdx
            let boardCol = piece.location.col
            
            for cellIdx in 0..<row.cells.count {
                let cell = row.cells[cellIdx]
                if !cell.occupied { continue }
                
                let location = Location(boardCol+cellIdx, boardRow)
                let canPlaceCell = overlay(cell,
                                           location: location,
                                           operation: operation)
                
                canMove = canMove && canPlaceCell
            }
            
        }
        
        return canMove
    }
    
    /// A location is considered valid if it is inside the board
    /// Any location that returns true here will be a valid (row,col)
    /// in the Rows array
    func validateLocation(_ location: Location) -> Bool {
        // We can't overlay a cell if it's not on the board
        if location.row >= 0,
           location.row < size.height,
           location.col >= 0,
           location.col < size.width {
            return true
        }
        return false
    }
    
    /// Overlays an individual cell onto the board at th given location
    /// using the given operation and returns true if the the cell we're
    /// overlaying onto is not occupied
    ///
    /// .add is indiscriminate here and will gladly overwrite any existing
    /// contents, should you need to
    func overlay(_ cell: Cell,
                 location: Location,
                 operation: OverlayType) -> Bool
    {
        // We assume cells above the board are never full and so
        // we simply return true here, but do nothing.  This allows
        // us to set the initial location of the piece to a negative
        // row value, so it animates onto the board
        if location.row < 0 {
            return true
        }
        
        // Check if the cell is on the board.  The piece location may
        // mean that some of its cells would lie outside the board.  By
        // definition, this is an invalid location.
        guard validateLocation(location) else {
            return false
        }
 
        // Grab the row onto which we're going to overlay the cell
        let row = rows[location.row]

        // We can place the new cell as long as the current cell is
        // not occupied
        let canPlace = (false == row.cells[location.col].occupied)
        
        switch operation {
        case .add:
            // If we're adding the cell, add it.
            row.cells[location.col] = cell
        case .remove:
            // If we're emptying the cell, set it to the empty cell
            row.cells[location.col] = Cell.empty()
        case .test:
            break
        }
        
        return canPlace
    }
    
    /// Returns all of the rows which are filled
    func filledRows() -> [Row] {
        let filledRows = rows.filter({ $0.filled() })
        return filledRows
    }
    
    /// Removes all of the rows which are filled and shifts remaining rows
    /// down
    func removeFilledRows() {
        self.rows = self.rows.filter { !$0.filled() }
        while self.rows.count < self.size.height {
            self.rows.insert(Row.emptyRow(self.size.width), at: 0)
        }
    }
}
