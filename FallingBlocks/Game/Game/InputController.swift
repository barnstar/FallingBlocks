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

typealias InputAction = () -> Void

enum GameInputAction {
    case left
    case right
    case rotate
    case drop
    
    static func fromKeyCode(_ code: GCKeyCode) -> GameInputAction? {
        switch code {
        case .leftArrow: return .left
        case .rightArrow: return .right
        case .downArrow: return .drop
        case .upArrow: return .rotate
        default: return nil
        }
    }
}

class InputController {
    
    var keyboardObserver: AnyCancellable?
    var gamepadObserver: AnyCancellable?

    var keyboardInput: GCKeyboardInput?
    var gamepadInput: GCController?

    @Published var downActive: Bool = false

    var actions: [GameInputAction: InputAction] = [:]
    
    init() {
        // This disables the keyclick for macOS when there's not active first responder
        // for keybaord events.  We cannot use NSEvent for game input
        // though since it's not going to cover all those iOS devices with physical
        // keybaords, so for that, we use GCKeyboardInput
        #if os(macOS)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { _ in return nil }
        #endif
        
        keyboardObserver = NotificationCenter.default
            .publisher(for: .GCKeyboardDidConnect)
            .sink { [weak self] notification in
                if let keyboard = (notification.object as? GCKeyboard)?.keyboardInput {
                    self?.setupKeyboardInput(keyboard)
                }
            }
        
        gamepadObserver = NotificationCenter.default
            .publisher(for: .GCControllerDidConnect)
            .sink { [weak self] notification in
                let controllers = GCController.controllers()
                if let controller = controllers.first(where: { $0.extendedGamepad != nil }) {
                    self?.setupGamePadHandler(controller)
                }
            }
    }
    
    // Register a callback that will be triggered whenever a given keycode is
    // observed
    func registerAction(gamePadInput: GameInputAction,
                        action: @escaping InputAction) {
        actions[gamePadInput] = action
    }
    
    // Resets the currently pressed key
    func resetActiveActions() {
        downActive = false
    }
}


// Keyboard Support
extension InputController {
    func setupKeyboardInput(_ keyboard: GCKeyboardInput) {
        keyboardInput = keyboard
        keyboardInput?.keyChangedHandler = self.handleKeyPress
    }
    
    func handleKeyPress(input: GCKeyboardInput,
                        button: GCControllerButtonInput,
                        code: GCKeyCode,
                        val: Bool) -> Void {
        guard let action = GameInputAction.fromKeyCode(code) else {
            return
        }

        switch button.isPressed {
        case false:
            if action == .drop {
                downActive = false
            }
        case true:
            if action == .drop {
                downActive = true
            }
            // Fetch the action for the key code and execute it
            actions[action]?()
        }
    }
}

// Gamepad Support
extension InputController {
    
    func setupGamePadHandler(_ controller: GCController) {
        self.gamepadInput = controller
        gamepadInput?.extendedGamepad!.buttonA.valueChangedHandler = aButtonHandler
        gamepadInput?.extendedGamepad!.dpad.valueChangedHandler = dpadHandler
    }

    func aButtonHandler(_ button: GCControllerButtonInput, val: Float, pressed: Bool) {
        if pressed, let action = actions[.rotate]{
            action()
        }
    }
    
    func dpadHandler(_ pad: GCControllerDirectionPad, x: Float, y:Float) {
        if x > 0, let action = actions[.right] {
            action()
        }
        if x < 0, let action = actions[.left] {
            action()
        }
        downActive = (y<0)
    }
}
