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

