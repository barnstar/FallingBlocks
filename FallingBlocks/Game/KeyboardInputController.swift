//
//  InputController.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-04.
//

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
