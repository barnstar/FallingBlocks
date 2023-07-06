//
//  PieceFactory.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-05.
//

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
