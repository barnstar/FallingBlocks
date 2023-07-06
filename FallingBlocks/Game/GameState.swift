//
//  GameState.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-03.
//

import Foundation

let kMaxLevel = 10
let kLinesPerLevel = 10


class GameStateViewModel: ObservableObject {
    @Published var scoreText: String = ""
    @Published var levelText: String = ""
    @Published var linesText: String = ""
    @Published var startButtonOpacity: Double = 1.0
    @Published var nextPiece: Piece?
}


class GameState: ObservableObject {
    enum GameStatus {
        case gameOn
        case gameOver
    }

    @Published var viewModel = GameStateViewModel()

    @Published var nextPiece: Piece? {
        didSet  {
            viewModel.nextPiece = nextPiece
        }
    }
    
    @Published var status: GameStatus = .gameOver {
        didSet {
            viewModel.startButtonOpacity = status == .gameOn ? 0.0 : 1.0
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
