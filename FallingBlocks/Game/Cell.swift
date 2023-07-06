//
//  Cell.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-05.
//

import Foundation
import SwiftUI

/// Pieces and the board are compose of cells.  Those cells can
/// be occupied and if they are, they have some associated properties
/// like color, opacity, etc we can use to draw or animate the cell
/// contents
class Cell: Animatable {
    var occupied: Bool = false
    var color: Color = .blue

    var animation: GameAnimation?
    
    /// Animatable properties.  The render is responsible for
    /// applying these
    var opacity: CGFloat = 1.0
    
    init() {}
    
    init(occupied: Bool, color: Color) {
        self.occupied = occupied
        self.color = color
    }
    
    static func empty() -> Cell {
        return Cell()
    }
    
    static func filled(_ color: Color) -> Cell {
        return Cell(occupied: true, color: color)
    }
}

