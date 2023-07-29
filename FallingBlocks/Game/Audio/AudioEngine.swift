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
import AVFoundation

class AudioEngine {
    var musicPlayer: AVAudioPlayer?
    var effectPlayers = [SoundEffects: AVAudioPlayer]()

    func startMusic(_ file: String? = "Theme1.m4a") {
        musicPlayer?.stop()
        do {
            let themeURL = Bundle.main.url(forResource: file, withExtension: nil)
            let theme = try Data(contentsOf: themeURL!)
            musicPlayer = try AVAudioPlayer(data: theme)
            musicPlayer?.numberOfLoops = -1
        } catch {
            print("Cannot load/play theme music")
        }
        musicPlayer?.play()
    }

    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }
    
    func registerEffect(data: Data, key: SoundEffects) throws {
        let effectPlayer = try AVAudioPlayer(data: data)
        effectPlayer.numberOfLoops = 0
        effectPlayers[key] = effectPlayer
    }
    
    func playSound(_ effect: SoundEffects) {
        let effectPlayer = effectPlayers[effect]
        effectPlayer?.play()
    }
}
