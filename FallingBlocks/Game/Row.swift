//
//  Row.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-03.
//

import Foundation
import SwiftUI

/// A row encapsulates an array of Cells with some nice
/// convenience functions
///
/// This could all be done as extensions on [Cell] but
/// the abstraction of a "Row" makes the code a bit nicer
/// to read and grok
class Row: Animatable {
    var cells: [Cell]
    var animation: GameAnimation?
    
    init(_ cells: [Cell]) {
        self.cells = cells
    }
    
    /// Returns the width of the row
    var width: Int {
        return cells.count
    }
    
    /// Returns true if the row is fully occupied
    func filled() -> Bool {
        // .reduce is probably the right operation here, but this is cleaner
        return cells.filter { $0.occupied }.count == cells.count
    }
    
    /// Returns a row of the given count filled with empty cells
    static func emptyRow(_ count: Int, index: Int = 0) -> Row {
        let cells = [Cell](repeating: .empty(), count: count)
        return Row(cells)
    }
}

extension [Row] {
    func fade(frames: Int, completion: AnimationCompletion? = nil) {
        guard self.count > 0, frames > 0 else {
            completion?()
            return
        }
        
        let animation = GameAnimation(frames: frames, action: { frameCount in
            self.forEach { row in
                row.cells.forEach { cell in
                    cell.opacity -= 1.0/Double(frames)
                }
            }
        }, completion: {
            self.first?.animation = nil
            completion?()
        })
        self.first!.animation = animation
    }
}

