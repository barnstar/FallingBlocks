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
#if os(macOS)
import Cocoa
#endif
import GameKit
import Combine

typealias InputActionCallback = () -> Void

// Represents the different possible user interactions/inputs
// for the game
enum GameInputAction {
    case left
    case right
    case rotate
    case drop
}

class InputController {

    // Non nil if we have an available keyboard input device
    var keyboardInput: GCKeyboardInput?
    
    // Non nil if we have a valid gamepad controller input device
    var gamepadInput: GCController?

    // Input actions that are currently active - ie: button is still pressed
    var activeActions = Set<GameInputAction>()
    
    // Callbacks to be invoked on a "button down" event
    var actionCallbacks: [GameInputAction: InputActionCallback] = [:]
    
    init() {
        // This disables the keyclick for macOS when there's not active first responder
        // for keybaord events.  We cannot use NSEvent for game input
        // though since it's not going to cover all those iOS devices with physical
        // keybaords, so for that, we use GCKeyboardInput
        #if os(macOS)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { _ in return nil }
        #endif
        
        watchForInputDevices()
    }
    
    private var keyboardObserver: AnyCancellable?
    private var gamepadObserver: AnyCancellable?
    
    func watchForInputDevices() {
        keyboardObserver = NotificationCenter.default
            .publisher(for: .GCKeyboardDidConnect)
            .sink { [weak self] notification in
                if let keyboard = (notification.object as? GCKeyboard)?.keyboardInput,
                   nil == self?.keyboardInput {
                    self?.setupKeyboardInput(keyboard)
                    self?.keyboardObserver = nil
                }
            }
        
        gamepadObserver = NotificationCenter.default
            .publisher(for: .GCControllerDidConnect)
            .sink { [weak self] notification in
                let controllers = GCController.controllers()
                if let controller = controllers.first(where: { $0.extendedGamepad != nil }),
                   nil == self?.gamepadInput {
                    self?.setupGamePadHandler(controller)
                    self?.gamepadObserver = nil
                }
            }
    }
    
    // Register a callback that will be triggered whenever a given keycode is
    // observed
    func registerAction(input: GameInputAction,
                        action: @escaping InputActionCallback) {
        actionCallbacks[input] = action
    }
    
    // Resets the currently pressed key
    func resetActiveActions() {
        activeActions.removeAll()
    }
}


// Keyboard Support
extension InputController {
    func setupKeyboardInput(_ keyboard: GCKeyboardInput) {
        keyboardInput = keyboard
        keyboardInput?.keyChangedHandler = self.handleKeyPress
        print("Keyboard input configured and available")
    }
    
    // Static mappying of the arrow keys to game actions.
    func actionFromKeyCode(_ code: GCKeyCode) -> GameInputAction? {
        switch code {
        case .leftArrow: return .left
        case .rightArrow: return .right
        case .downArrow: return .drop
        case .upArrow: return .rotate
        default: return nil
        }
    }
    
    func handleKeyPress(input: GCKeyboardInput,
                        button: GCControllerButtonInput,
                        code: GCKeyCode,
                        val: Bool) -> Void {
        guard let action = actionFromKeyCode(code) else {
            return
        }

        switch button.isPressed {
        case false:
            activeActions.remove(action)
        case true:
            activeActions.insert(action)
            // Fetch the action for the key code and execute it
            actionCallbacks[action]?()
        }
    }
}

// Gamepad Support
extension InputController {
    
    func setupGamePadHandler(_ controller: GCController) {
        self.gamepadInput = controller
        gamepadInput?.extendedGamepad!.buttonA.valueChangedHandler = rotateButtonHandler
        gamepadInput?.extendedGamepad!.dpad.valueChangedHandler = movementHandler
        print("Gamepad input configured and available")
    }

    func rotateButtonHandler(_ button: GCControllerButtonInput, val: Float, pressed: Bool) {
        if let action = actionCallbacks[.rotate]{
            switch pressed {
            case true:
                activeActions.insert(.rotate)
                action()
            case false:
                activeActions.remove(.rotate)
            }
        }
    }
    
    func movementHandler(_ pad: GCControllerDirectionPad, x: Float, y:Float) {
        if x > 0, let action = actionCallbacks[.right] {
            activeActions.insert(.right)
            action()
        }
        else if x < 0, let action = actionCallbacks[.left] {
            activeActions.insert(.left)
            action()
        }
        else if x == 0 {
            activeActions.remove(.left)
            activeActions.remove(.right)
        }
        
        if y < 0 {
            activeActions.insert(.drop)
        } else {
            activeActions.remove(.drop)
        }
    }
}
