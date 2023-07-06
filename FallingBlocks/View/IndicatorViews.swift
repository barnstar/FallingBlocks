//
//  IndicatorViews.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-03.
//

import Foundation
import SwiftUI

#if os(macOS)
let kIndicatorFontSize = 16.0
#else
let kIndicatorFontSize = 16.0
#endif

extension Text {
    func indicatorStyle() -> some View {
        self
            .font(Font.system(size: kIndicatorFontSize, weight: .black))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
    }
}

struct StartButton: View {
    @StateObject var model: GameStateViewModel
    var action: ()->Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fillShadow(.red)
                Text("Start")
                    .indicatorStyle()
            }
        }
        .buttonStyle(.borderless)
        .frame(height: 60)
        .opacity(model.startButtonOpacity)
    }
}

struct ScoreView: View {
    @ObservedObject var model: GameStateViewModel
    
    @State var scale: Double = 1.0
    
    var body: some View {
        ZStack {
            Rectangle()
                .fillShadow(.orange)
                .scaleEffect(scale)
                .onReceive(model.$scoreText) { _ in
                    self.animation(.easeInOut, value: scale)
                }
                
            Text(model.scoreText)
                .indicatorStyle()

        }
        .frame(height: 60)
    }
}

struct LinesView: View {
    @ObservedObject var model: GameStateViewModel

    var body: some View {
        ZStack {
            Rectangle()
                .fillShadow(.green)
            Text(model.linesText)
                .indicatorStyle()
        }
        .frame(height: 60)
    }
}

struct LevelView: View {
    @ObservedObject var model: GameStateViewModel
    

    var body: some View {
        ZStack {
            Rectangle()
                .fillShadow(.blue)
            Text(model.levelText)
                .indicatorStyle()

        }
        .frame(height: 60)
    }
}


