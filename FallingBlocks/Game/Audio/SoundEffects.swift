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


enum SoundEffectError: Error {
    case missingFile
}

//Effects are expected to be in this format with the file
//names equal to the rawValue of the SoundEffects enum
//Misssing/malformed files will simply be ignored
let kEffectFormat = "mp3"

enum SoundEffects: String, CaseIterable {
    case gameOver
    case oneLine
    case fourLines
    case levelUp
    case placePiece
    
    func effectData() throws -> Data {
        if let url = Bundle.main.url(forResource: self.rawValue, withExtension: kEffectFormat) {
            let effectData = try Data(contentsOf: url)
            return effectData
        }
        throw SoundEffectError.missingFile
    }
}

extension SoundEffects {
    static func effectForLineCount(_ count: Int) -> SoundEffects? {
        switch count {
        case 0: return .placePiece
        case 1...3: return .oneLine
        case 4: return .fourLines
        default: return nil
        }
    }
}

extension AudioEngine {
    func registerAllEffects() {
        SoundEffects.allCases.forEach { effect in
            do {
                let data = try effect.effectData()
                try registerEffect(data: data, key: effect)
            } catch {
                print("No data for effect \(effect)")
            }
        }
    }
}
