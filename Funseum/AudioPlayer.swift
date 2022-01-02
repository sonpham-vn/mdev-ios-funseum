//
//  AudioPlayer.swift
//  Funseum
//
//  Created by SonPT on 2021-12-09.
//

import Foundation
import AVKit

class SoundManager : ObservableObject {
    var audioPlayer: AVPlayer?

    func playSound(sound: String){
        if let url = URL(string: sound) {
            self.audioPlayer = AVPlayer(url: url)
        }
    }
}
