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
    let inputController = InputController()
    
    // The primary game timer.  This is independent from whatever
    // magic SwiftUI is doing with that very suspect TimelineView
    var gameTimer: AnyCancellable?
    
    // Fires every time the piece should automatically drop
    var dropTimer: AnyCancellable?
    
    // Observes changes to the level in the gamestate so we can increase
    // the drop rate.  The gamestate updates the level via the number of
    // lines
    var levelObserver: AnyCancellable?
    
    let audioEngine = AudioEngine()
    
    init() {
        // Reset our gamestate to it's default ready state
        gameState.resetScore()
        
        // Register the action we need to take on different keypresses
        registerInputActions()
        
        audioEngine.registerAllEffects()

        
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
                if level > 1 {
                    self.audioEngine.playSound(.levelUp)
                }
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
        guard gameState.status == .gameOn else {
            return
        }
        
        if inputController.activeActions.contains(.drop) {
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
            inputController.resetActiveActions()
            
            // Check for any filled lines
            let filledRows = board.filledRows()
            
            // Run an animation on the opacity for the filled
            // rows, then delete them
            filledRows.fade(frames: 6) {
                // Update the number of lines which will update the score/levvel
                self.gameState.addLines(filledRows.count)
                
                // Remove any filled rows
                self.board.removeFilledRows()
                
                if let effect = SoundEffects.effectForLineCount(filledRows.count) {
                    self.audioEngine.playSound(effect)
                }
                
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
            audioEngine.stopMusic()
            audioEngine.playSound(.gameOver)
        }
    }
    
    func pause() {
        gameState.status = .paused
        audioEngine.musicPlayer?.pause()
    }
    
    // Starts/resume or pauses the game
    func startPause() {
        switch gameState.status {
        case .gameOver:
            board.reset()
            gameState.startGame()
            spawnPiece()
            audioEngine.startMusic()
        case .gameOn:
            pause()
        case .paused:
            gameState.status = .gameOn
            audioEngine.musicPlayer?.play()
        }
    }


    
    func registerInputActions() {
        inputController.registerAction(input: .rotate) { [weak self] in
            self?.board.rotateActivePiece(.left)
        }
        
        inputController.registerAction(input: .right) { [weak self] in
            self?.board.moveActivePiece(.right)
        }
        
        inputController.registerAction(input: .left) { [weak self] in
            self?.board.moveActivePiece(.left)
        }
    }

}


