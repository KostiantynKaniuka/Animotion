//
//  VideoPlayer.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 27.06.2023.
//

import UIKit
import AVKit
import SnapKit

final class VideoPlayer: AVPlayerViewController {
    private let loadingIndicatir: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.frame.size = CGSize(width: 100, height: 80)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    private var videoItem = AVMutableMetadataItem()
    private var subtitleItem = AVMutableMetadataItem()
    private var playeritem: AVPlayerItem?
    var link: String = ""
    var videoTitle: String?
    var videoSubtitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicatir.startAnimating()
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
        
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
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
        
        view.addSubview(loadingIndicatir)
        loadingIndicatir.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            if #available(iOS 10.0, *) {
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                if newStatus != oldStatus {
                    DispatchQueue.main.async {[weak self] in
                        if newStatus == .playing || newStatus == .paused {
                            self?.loadingIndicatir.stopAnimating()
                        } else {
                            self?.loadingIndicatir.startAnimating()
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
                self.loadingIndicatir.stopAnimating()
            }
        }
    }
    
    deinit {
        print("➡️ Player gone")
    }
}
