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


struct PieceFactory {
    /// Creates a piece in the given orientation and location
    static func createPiece(_ style: Piece.Style,
                            initialOrientation: Orientation,
                            initialLocation: Location) -> Piece {
        let retVal = Piece(style: style, location: initialLocation)
        PieceFactory.setConfigurations(piece: retVal)
        
        return retVal
    }
    
    /// Creates a random piece a the given location with it's orientation
    /// set to "up"
    static func randomPiece(at location: Location) -> Piece {
        let type = Piece.Style.randomStyle()
        let retVal = PieceFactory.createPiece(type,
                                              initialOrientation: .up,
                                              initialLocation: location)
        return retVal
    }
    
    
    /// This is superbly ugly.  I'm sure we could do something fancy
    /// like define all our piece orientations as strings and parse
    /// them into multidimensional arrays.
    static func setConfigurations(piece: Piece) {
        switch piece.style {
            
        case .long:
            let color: Color = .red
            piece.configurations[.up] = [Row([.filled(color)]),
                                         Row([.filled(color)]),
                                         Row([.filled(color)]),
                                         Row([.filled(color)])]
            
            piece.configurations[.left] = [Row([.filled(color), .filled(color), .filled(color), .filled(color)])]
            
            piece.configurations[.right] = piece.configurations[.left]
            piece.configurations[.down] = piece.configurations[.up]

            piece.previewOrientation = .left
            break
            
        case .square:
            let c: Color = .blue
            piece.configurations[.up] = [Row([.filled(c), .filled(c)]),
                                         Row([.filled(c), .filled(c)])]
            
            piece.configurations[.down] = piece.configurations[.up]
            piece.configurations[.left] = piece.configurations[.up]
            piece.configurations[.right] = piece.configurations[.up]
            break

        case .tee:
            let c: Color = .green
            piece.configurations[.up]    = [Row([.empty(),   .filled(c),  .empty()]),
                                            Row([.filled(c), .filled(c),  .filled(c)])]
            
            piece.configurations[.down]  = [Row([.filled(c), .filled(c),  .filled(c)]),
                                            Row([.empty(),   .filled(c),  .empty()])]
            
            piece.configurations[.left]  = [Row([.empty(),   .filled(c)]),
                                            Row([.filled(c), .filled(c)]),
                                            Row([.empty(),   .filled(c)])]
            
            piece.configurations[.right] = [Row([.filled(c), .empty()]),
                                            Row([.filled(c), .filled(c)]),
                                            Row([.filled(c), .empty()])]
            break

        case .sLeft:
            let c: Color = .purple

            piece.configurations[.up]    = [Row([.empty(),   .filled(c),  .filled(c)]),
                                            Row([.filled(c), .filled(c),  .empty()])]
            
            piece.configurations[.left]  = [Row([.filled(c), .empty()]),
                                            Row([.filled(c), .filled(c)]),
                                            Row([.empty(),   .filled(c)])]
            
            piece.configurations[.right] = piece.configurations[.left]
            piece.configurations[.down] = piece.configurations[.up]

            
            break

        case .sRight:
            let c: Color = .orange

            piece.configurations[.up]    = [Row([.filled(c),   .filled(c),  .empty()]),
                                            Row([.empty(),     .filled(c),  .filled(c)])]
            
            piece.configurations[.left]  = [Row([.empty(),   .filled(c)]),
                                            Row([.filled(c), .filled(c)]),
                                            Row([.filled(c), .empty()])]
            
            piece.configurations[.down]  = piece.configurations[.up]
            piece.configurations[.right] =  piece.configurations[.left]
            break
        case .lRight:
            let c: Color = .yellow

            piece.configurations[.up]    = [Row([.empty(),     .empty(),   .filled(c)]),
                                            Row([.filled(c),   .filled(c), .filled(c)])]
            
            piece.configurations[.down]  = [Row([.filled(c),   .filled(c), .filled(c)]),
                                            Row([.filled(c),   .empty(),   .empty()])]
            
            piece.configurations[.right] = [Row([.filled(c),   .empty()]),
                                            Row([.filled(c),   .empty()]),
                                            Row([.filled(c),   .filled(c)])]
            
            piece.configurations[.left]  = [Row([.filled(c),   .filled(c)]),
                                            Row([.empty(),     .filled(c)]),
                                            Row([.empty(),     .filled(c)])]
            break
        case .lLeft:
            let c: Color = .pink

            piece.configurations[.up]    = [Row([.filled(c),   .empty(),   .empty()]),
                                            Row([.filled(c),   .filled(c), .filled(c)])]
            
            piece.configurations[.down]  = [Row([.filled(c),   .filled(c), .filled(c)]),
                                            Row([.empty(),     .empty(),   .filled(c)])]
            
            piece.configurations[.right] = [Row([.empty(),     .filled(c)]),
                                            Row([.empty(),     .filled(c)]),
                                            Row([.filled(c),   .filled(c)])]
            
            piece.configurations[.left]  = [Row([.filled(c),   .filled(c)]),
                                            Row([.filled(c),   .empty()]),
                                            Row([.filled(c),   .empty()])]
            break
        }
    }
}
