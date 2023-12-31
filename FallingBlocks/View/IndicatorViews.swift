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

let kIndicatorFontSize = 16.0

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
                    .fillShadow(model.startButtonColour)
                Text(model.startButtonText)
                    .indicatorStyle()
            }
        }
        .buttonStyle(.borderless)
        .frame(height: 60)
    }
}

struct ScoreView: View {
    @ObservedObject var model: GameStateViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fillShadow(.orange)
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


