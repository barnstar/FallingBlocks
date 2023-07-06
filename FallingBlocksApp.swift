//
//  FallingBlocksApp.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-02.
//

import SwiftUI

@main
struct FallingBlocksApp: App {
    var gameController = FBGameController()
    
    var body: some Scene {
        WindowGroup {
                GameView()
                    #if os(macOS)
                    .frame(minWidth: 400, maxWidth: 400 , minHeight: 600, maxHeight: 600, alignment: .center)
                    #endif
                    .environmentObject(gameController)
                    .environmentObject(gameController.gameState)
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        #endif
    }
}
