//
//  CellAnimation.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-05.
//

import Foundation


typealias AnimationAction = (Int) -> Void
typealias AnimationCompletion = () -> Void

/// Animatable things can associate an animation
protocol Animatable {
    var animation: GameAnimation? { get set }
}

/// An animator is responsible for running the animations
/// on ever object it's responsible for
protocol Animator {
    func animate()
}

/// An animation consists of a set of frames and an action
/// that is performed on each frame.  The completion block is
/// run when immediately after the final frame is rendered.
class GameAnimation {
    var remainingFrames: Int
    var animationAction: AnimationAction
    var animationCompletion: AnimationCompletion?
    
    var finished: Bool {
        return remainingFrames == 0
    }
    
    init(frames: Int,
         action: @escaping AnimationAction,
         completion: AnimationCompletion? = nil) {
        remainingFrames = frames
        animationAction = action
        animationCompletion = completion
    }
    
    @discardableResult
    func runAnimation() -> Bool {
        guard !finished else { return true }
        
        remainingFrames -= 1
        animationAction(remainingFrames)

        if finished {
            animationCompletion?()
        }
        
        return finished
    }
}

/// Convenience function for all animatable objects to
/// quickly tell us if they're mid-animation
extension Animatable {
    func isAnimating() -> Bool {
        guard let animation = animation else {
            return false
        }
        return animation.finished
    }
}

