//
//  Rotation.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-02.
//

import Foundation

enum Movement {
    case left
    case right
    case down
}

enum Rotation {
    case left
    case right
}

enum Orientation {
    case up
    case down
    case left
    case right
    
    func next(_ direction: Rotation) -> Orientation {
        switch direction {
        case .left:
            switch self {
            case .up: return .left
            case .left: return .down
            case .down: return .right
            case .right: return .up
            }
        case .right:
            switch self {
            case .up: return .right
            case .left: return .up
            case .down: return .left
            case .right: return .down
            }
        }
    }
}
