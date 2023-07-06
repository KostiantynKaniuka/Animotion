//
//  VideoPlayer.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 27.06.2023.
//

import UIKit
import AVKit

class VideoPlayer: AVPlayerViewController {
   var link = ""


    override func viewDidLoad() {
        super.viewDidLoad()
       play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // link = ""
    }
    
    private func play() {
        let url = URL(string: link)
        let item = AVPlayerItem(url: url!)
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
    
    private func stop() {
          player?.pause()
          player = nil
          
//          if let observer = playerObserver {
//              NotificationCenter.default.removeObserver(observer)
//              playerObserver = nil
          
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
