//
//  GameController.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-02.
//

import Foundation
import SwiftUI
import Combine

/// The rate at which the SwiftUI canvans will udpate
/// and the rate at which well check for pressed keys
let kFrameRate: Double = 1.0/30.0

/// This is the default starting location for new pieces
let kStartingLocation: Location = (4,-1)

class FBGameController: ObservableObject
{
    // The board
    let board: Board = Board()
    
    // The state of the game.  Publishes a couple of viewModels
    // for our SwiftUI interfaces
    let gameState = GameState()
    
    // Reads and tracks key presses
    let inputController = KeyboardInputController()
    
    // The primary game timer.  This is independent from whatever
    // magic SwiftUI is doing with that very suspect TimelineView
    var gameTimer: AnyCancellable?
    
    // Fires every time the piece should automatically drop
    var dropTimer: AnyCancellable?
    
    // Observes changes to the level in the gamestate so we can increase
    // the drop rate.  The gamestate updates the level via the number of
    // lines
    var levelObserver: AnyCancellable?

    init() {
        // Reset our gamestate to it's default ready state
        gameState.resetScore()
        
        // Register the action we need to take on different keypresses
        registerInputActions()

        
        // Fire up the game times and waste the users battery
        gameTimer = Timer
            .publish(every: kFrameRate, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] val in
                self?.tick()
            }
        
        // Oberve the current level, so we can set the game speed
        levelObserver = gameState.$level
            .sink { level in
                self.setSpeed(level)
            }
    }
    
    /// Sets the game speed based on the level
    func setSpeed(_ level: Int) {
        // Fancy math... Seems about right
        let dropDelay: TimeInterval = 1.0 - Double(level) / 11.0
        
        dropTimer = Timer
            .publish(every: dropDelay, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] val in
                self?.dropPiece()
            }
    }
    
    /// Call on every clock tick.  This should check the input actions and
    /// update any running animations
    func tick() {
        if inputController.activeKeyCode == .downArrow {
            dropPiece()
        }
        
        // Animate our animatable thigns
        board.animate()
    }
    
    /// Drops the piece by one square.  If that fails, we spawn
    /// a new piece and if *that* fails, we end the game
    func dropPiece() {
        guard gameState.status == .gameOn else {
            return
        }
        
        let didMove = board.moveActivePiece(.down)
        if false == didMove {
            // We're about to spawn a new piece.  Notably, for dropping,
            // we want to ignore things if you leave your finger on the
            // down button
            inputController.resetActiveKeyCode()
            
            // Check for any filled lines
            let filledRows = board.filledRows()
            
            // Run an animation on the opacity for the filled
            // rows, then delete them
            filledRows.fade(frames: 6) {
                // Update the number of lines which will update the score/levvel
                self.gameState.addLines(filledRows.count)
                
                // Remove any filled rows
                self.board.removeFilledRows()

                self.spawnPiece()
            }
        }
    }
    
    // Spawns a new piece if possible, and ends the game if
    // the spawn fails.
    func spawnPiece() {
        // The gameState will track the 'pending' peice, give that
        // to us, and update the pending piece to a new random one
        let piece = gameState.popAndRandomizeNextPiece()
        
        // It's gameover if we cannot spawn a piece
        if false == board.addActivePiece(piece) {
            board.activePiece = nil
            gameState.status = .gameOver
        }
    }
    
    // Starts the game
    func start() {
        board.reset()
        gameState.startGame()
        spawnPiece()
    }
    
    func registerInputActions() {
        inputController.registerActionForCode(.upArrow) { [weak self] in
            self?.board.rotateActivePiece(.left)
        }
        
        inputController.registerActionForCode(.rightArrow) { [weak self] in
            self?.board.moveActivePiece(.right)
        }
        
        inputController.registerActionForCode(.leftArrow) { [weak self] in
            self?.board.moveActivePiece(.left)
        }
    }

}


