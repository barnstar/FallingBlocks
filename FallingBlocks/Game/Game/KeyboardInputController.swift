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
import GameKit
import Combine

typealias InputAction = () -> Void

class KeyboardInputController {
    
    var inputDevice: GCKeyboardInput?
    var keyboardObserver: AnyCancellable?
    
    @Published var activeKeyCode: GCKeyCode?
    
    var actionMap: [GCKeyCode: InputAction] = [:]
    
    init() {
        // The only? way to get a keyboard device is to listen to this
        // connection even.  This always seems to trigger on devices with
        // a physical keybaord attached (including simulators)
        keyboardObserver = NotificationCenter.default
            .publisher(for: .GCKeyboardDidConnect)
            .sink { notification in
                self.inputDevice = (notification.object as! GCKeyboard).keyboardInput
                self.inputDevice?.keyChangedHandler = self.handleKeyPress
            }
    }
    
    // Register a callback that will be triggered whenever a given keycode is
    // observed
    func registerActionForCode(_ code: GCKeyCode, action: @escaping InputAction) {
        actionMap[code] = action
    }
    
    // Resets the currently pressed key
    func resetActiveKeyCode() {
        activeKeyCode = nil
    }
    
    func handleKeyPress(input: GCKeyboardInput,
                        button: GCControllerButtonInput,
                        code: GCKeyCode,
                        val: Bool) -> Void {
        switch button.isPressed {
        case false:
            activeKeyCode = nil
        case true:
            activeKeyCode = code
            // Fetch the action for the key code and execute it
            actionMap[code]?()
        }
    }
    
}
