//
//  VideoPlayer.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 27.06.2023.
//

import UIKit
import AVKit

class VideoPlayer: AVPlayerViewController {
    let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/animotion-b77b1.appspot.com/o/videos%2FMovies%2Fgogolumorya.mov?alt=media&token=37a6911d-b7f5-46c3-8553-4dadb9d19b73")
    lazy var item = AVPlayerItem(url: videoURL!)

    override func viewDidLoad() {
        super.viewDidLoad()
        let player = AVPlayer(playerItem: item)
        self.player = player
        self.player?.play()
        self.player?.volume = 1
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
        } catch {
            // Handle the error
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Extend the player's view beyond the safe area
        if let contentView = self.view.subviews.first, let playerView = contentView.subviews.first {
            playerView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
        }
    }
    
    deinit {
        print("➡️ Player gone")
    }
}
