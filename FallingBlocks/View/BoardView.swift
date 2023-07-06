//
//  BoardView.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-03.
//

import Foundation
import SwiftUI

struct BoardView: View {
    var controller: FBGameController
    let renderer = BoardRenderer()

    var body: some View {
        TimelineView(.periodic(from: .now, by: kFrameRate)) { timeline in
            Canvas{ context, size in
                _ = timeline.date.timeIntervalSinceReferenceDate
                renderer.render(board: controller.board,
                                context: &context,
                                size: size)
            }
        }
    }
}
