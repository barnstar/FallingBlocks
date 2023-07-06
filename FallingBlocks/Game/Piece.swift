//
//  Piece.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-02.
//

import Foundation
import SwiftUI

typealias Size = (width: Int, height: Int)

/// A gamepiece.  Pieces have a style, location and set
/// of "configurations" which define arrays of "Cells" in
/// any given rotation
class Piece {
    enum Style: CaseIterable {
        case long
        case square
        case tee
        case sLeft
        case sRight
        case lRight
        case lLeft
        
        // Returns a random style
        static func randomStyle() -> Style {
            Style.allCases.randomElement()!
        }
    }
    
    /// The pieces style
    var style: Style
    
    /// A map of [Row] keyed by .orientation.
    /// Pieces must ahve configurations for all 4 orientations or
    /// bad things will happen.  See PieceFactory.setConfigurations(piece:)
    var configurations: [Orientation: [Row]] = [:]
    
    /// The location of it's origin in board-space
    var location: Location = (0,0)

    /// The current orientation of the piece
    var orientation: Orientation = .up
    
    /// The orientation to render the piece's preview in
    var previewOrientation: Orientation = .up
    
    /// Do not call this directly.  Use the PieceFactory, which will
    /// apply all of the correct configurations
    init(style: Style, location: Location) {
        self.style = style
        self.location = location
    }
    
    /// Rotate's the piece in the given direction by updating its orientation
    func rotate(_ direction: Rotation) {
        orientation = orientation.next(direction)
    }
    
    /// Retunrs the size of the pice in its current orientation
    func size() -> Size {
        let config = configurations[orientation]!
        return (config[0].width, config.count)
    }
    
    /// Returns and array of Rows-of-cells in the piece's
    /// current orientation
    func rows() -> [Row] {
        return configurations[orientation]!
    }
}

