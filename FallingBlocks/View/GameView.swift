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


import SwiftUI

struct Layout {
    let kBoardWidthFraction = 0.75
}

struct GameView: View {
    @EnvironmentObject var gameController: FBGameController
    @EnvironmentObject var gameState: GameState

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Blocks")
                    .resizable()
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
                
                VStack {
                    Spacer().frame(height: 5)
                    HeaderView()
                    Spacer().frame(height: 5)
                    
                    HStack {
                        VStack {
                            BoardView(controller: gameController)
                                .cornerRadius(4.0)
                                .shadow(color: .black, radius: 2.0, x: 4.0, y: 4.0)
                                .frame(width: geometry.size.width*0.7,
                                       height: geometry.size.height*0.8)
                        }.padding(5)
                        
                        
                        VStack(alignment: .leading){
                            Spacer.vertical(60)
                            
                            ScoreView(model: gameState.viewModel)
                            
                            LinesView(model: gameState.viewModel)
                            
                            LevelView(model: gameState.viewModel)
                            
                            Spacer.vertical(10)
                            
                            PiecePreview (model: gameState.viewModel)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.1)
                                .background {
                                    Color(.black).opacity(0.8)
                                }
                                .cornerRadius(2.0)
                            
                            Spacer.vertical(30)
                            
                            StartButton(model: gameState.viewModel) {
                                gameController.start()
                            }
                            
                            Spacer()
                        }
                        .padding(5)
                        .frame(width: geometry.size.width * 0.2)
                    }
                }
            }
        }
    }
}

struct HeaderView: View {
    #if os(macOS)
    let kHeaderFontSize = 36.0
    #else
    let kHeaderFontSize = 36.0
    #endif
    
    var body: some View {
        ZStack {
            Text("    Falling Blocks    ")
                .font(Font.system(size: kHeaderFontSize))
                .fontWeight(.black)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 5.0)
        }
        .background {
            Color(.black).opacity(0.5)
        }
        .cornerRadius(10.0)
    }
}

struct GameBoard_Previews: PreviewProvider {
    static var gameController = FBGameController()

    static var previews: some View {
        BoardView(controller: gameController)
            .environmentObject(gameController)
            .environmentObject(gameController.gameState)
    }
}
