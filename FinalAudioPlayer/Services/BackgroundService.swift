//
//  BackgroundService.swift
//  FinalAudioPlayer
//
//  Created by Taha Hussein on 15/11/2023.
//

import Foundation
import MediaPlayer
protocol BackgroundServiceProtocol {
    func updateMetadataContent(item: PlaylistItem)
    func updateTotalDuration(totalDuration: Double)
    func updatecurrentDuration(currentDuration: Double)
}

protocol BackgroundServiceInputProtocol {
    var commandCenter: MPRemoteCommandCenter { get set }
    var nowPlayingInfo: [String: Any] { get set }
}

protocol BackgroundProtocol: BackgroundServiceProtocol,BackgroundServiceInputProtocol{}
class BackgroundService: BackgroundProtocol {
    var commandCenter = MPRemoteCommandCenter.shared()
    var nowPlayingInfo = [String: Any]()
    var nextClosure:(()->())?
    var previousClosure:(()->())?
    var playClosure:(()->())?
    var pauseClosure:(()->())?
    var toggleClosure:(()->())?
    var changePositionClosure:((Float)->())?
    init() {
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.playClosure?()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pauseClosure?()
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.toggleClosure?()
            return .success
            
        }
        
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.nextClosure?()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.previousClosure?()
            return .success
        }
        
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            
            let positionTime = event.positionTime
            self?.changePositionClosure?(Float(positionTime))
            return .success
        }
    }
    
    func updateMetadataContent(item: PlaylistItem) {
        if let title = item.title {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
        }
        
        if let artist = item.artist {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }
        
        guard let url = URL(string: item.cover ?? "") else { return }
        ImageLoader.image(for: url) {[weak self] image in
            if let albumArt = image {
                self?.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: albumArt.size, requestHandler: { (size) -> UIImage in
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self?.nowPlayingInfo
                    return albumArt
                })
            }
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func updateTotalDuration(totalDuration: Double) {
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = totalDuration
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

    }
    
    func updatecurrentDuration(currentDuration: Double) {
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentDuration
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

    }
}
