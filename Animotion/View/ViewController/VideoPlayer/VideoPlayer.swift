//
//  VideoPlayer.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 27.06.2023.
//

import UIKit
import AVKit

final class VideoPlayer: AVPlayerViewController {
    private var videoItem = AVMutableMetadataItem()
    private var subtitleItem = AVMutableMetadataItem()
    private var playeritem: AVPlayerItem?
    var link: String = ""
    var videoTitle: String?
    var videoSubtitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        play()
    }
    
    private func play() {
        let url = URL(string: link)
        videoItem.identifier = .commonIdentifierTitle
        videoItem.value = videoTitle as (NSCopying & NSObjectProtocol)?
        
        var metadataItems: [AVMutableMetadataItem] = [videoItem]
        
        if videoSubtitle != "" {
            subtitleItem.identifier = .iTunesMetadataTrackSubTitle
            subtitleItem.value = videoSubtitle as (NSCopying & NSObjectProtocol)?
            metadataItems.append(subtitleItem)
        }
        
        let asset = AVURLAsset(url: url!)
        playeritem = AVPlayerItem(asset: asset)
        playeritem?.externalMetadata = metadataItems
        
        let player = AVPlayer(playerItem: playeritem)
        player.preventsDisplaySleepDuringVideoPlayback = true
        self.player = player
        player.play()
        
        self.player?.volume = 1
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let contentView = self.view.subviews.first, let playerView = contentView.subviews.first {
            playerView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
        }
    }
    
    deinit {
        print("➡️ Player gone")
    }
}
