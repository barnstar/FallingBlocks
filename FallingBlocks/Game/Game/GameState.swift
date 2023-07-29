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

let kMaxLevel = 10
let kLinesPerLevel = 10


class GameStateViewModel: ObservableObject {
    @Published var scoreText: String = ""
    @Published var levelText: String = ""
    @Published var linesText: String = ""
    @Published var startButtonText: String = ""
    @Published var startButtonColour: Color = .red
    @Published var nextPiece: Piece?
}


class GameState: ObservableObject {
    enum GameStatus {
        case gameOn
        case gameOver
        case paused
    }

    @Published var viewModel = GameStateViewModel()

    @Published var nextPiece: Piece? {
        didSet  {
            viewModel.nextPiece = nextPiece
        }
    }
    
    @Published var status: GameStatus = .gameOver {
        didSet {
            switch status {
            case .gameOn:
                viewModel.startButtonText = "Pause"
                viewModel.startButtonColour = .orange
            case .gameOver:
                viewModel.startButtonText = "Start"
                viewModel.startButtonColour = .green
            case .paused:
                viewModel.startButtonText = "Resume"
                viewModel.startButtonColour = .yellow
            }
        }
    }

    @Published var score: Int = 0 {
        didSet {
            viewModel.scoreText = "Score\n\(score)"
        }
    }
    
    @Published var lines: Int = 0 {
        didSet {
            viewModel.linesText = "Lines\n\(lines)"
        }
    }
 
    @Published var level: Int = 0 {
        didSet {
            viewModel.levelText = "Level\n\(level)"
        }
    }
    
    init() {
        resetScore()
    }
    
    /// Resets the score, level, lines, nextPiece, etc to their
    /// default starting values and sets the gameState to .gameOver
    func resetScore() {
        level = 1
        score = 0
        lines = 0
        
        nextPiece = nil
        status = .gameOver
    }

    /// Starts a new game
    func startGame() {
        resetScore()
        status = .gameOn
        nextPiece = PieceFactory.randomPiece(at: kStartingLocation)
    }
    
    /// Increments the level by 1 to a maximum of 10
    func incrementLevel() {
        if level < kMaxLevel {
            level += 1
        }
    }
    
    /// Adds to the line counter and upates the level if required.
    func addLines(_ lineCount: Int) {
        lines += lineCount
        if lineCount > 0 {
            score += 10 + (lineCount - 1) * 40
        }
        
        if lineCount > 0 && lines % kLinesPerLevel == 0 {
            incrementLevel()
        }
    }
    
    /// Generates a new "nextPiece" and returns the previous "nextPiece"
    func popAndRandomizeNextPiece() -> Piece {
        let piece = nextPiece ?? PieceFactory.randomPiece(at: kStartingLocation)
        nextPiece = PieceFactory.randomPiece(at: kStartingLocation)
        return piece
    }
}
