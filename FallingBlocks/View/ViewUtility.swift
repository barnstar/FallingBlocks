//
//  ViewUtility.swift
//  FallingBlocks
//
//  Created by Jonathan Nobels on 2023-07-03.
//

import Foundation
import SwiftUI

extension Spacer {
    static func vertical(_ size: Double) -> some View {
        return Spacer().frame(height: size)
    }
}


extension Rectangle {
    func fillShadow(_ color: Color, cornerRadius: Double = 5.0) -> some View {
        self
            .fill(color)
            .cornerRadius(cornerRadius)
            .shadow(color: .black, radius: 1.0, x: 2.0, y: 2.0)
   }
}


