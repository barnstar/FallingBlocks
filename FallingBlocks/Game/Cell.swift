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

