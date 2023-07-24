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

