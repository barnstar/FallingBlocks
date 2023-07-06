//
//  PiecePreview.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-03.
//

import Foundation
import SwiftUI

struct PiecePreview: View {
    @ObservedObject var model: GameStateViewModel
    let renderer: PieceRenderer = PieceRenderer()
    
    var body: some View {
        VStack {
            Canvas { context, size in
                renderer.render(piece: model.nextPiece, context: &context, size: size)
            }
        }
    }
    
}
