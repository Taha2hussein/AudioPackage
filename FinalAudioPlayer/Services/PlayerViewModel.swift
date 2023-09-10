//
//  PlayerViewModel.swift
//  FinalAudioPlayer
//
//  Created by Taha Hussein on 30/08/2023.
//

import AudioStreaming
import Foundation
import UIKit

enum ReloadAction {
    case all
    case item(IndexPath)
}

final class PlayerViewModel {
    private var playerService: AudioPlayerService
    private let playlistItemsService: PlaylistItemsService
//    private var equaliserService: EqualizerService

//    private let routeTo: (AppCoordinator.Route) -> Void
    private var currentPlayingItemIndex: Int?

    var reloadContent: ((ReloadAction) -> Void)?

    init(playlistItemsService: PlaylistItemsService,
         playerService: AudioPlayerService)
    {
        self.playlistItemsService = playlistItemsService
        self.playerService = playerService
        self.playerService.delegate.add(delegate: self)
    }

    var itemsCount: Int {
        playlistItemsService.itemsCount
    }

    func add(id: String , title: String , album: String , artist: String ,genre: String , url: String) {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        _ = detector.firstMatch(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count))

        playlistItemsService.add(item: PlaylistItem(id: id, audioURL: url, title: title, album: album, artist: artist, genre: genre, status: .stopped, queues: false))
        
        reloadContent?(.all)
    }

    func item(at indexPath: Int) -> PlaylistItem? {
        playlistItemsService.item(at: indexPath)
    }

   
    func playItem(with url: URL) {
        playerService.queue(url: url)
    }
    
    func getCurrentPlayingIndex() -> Int {
        return currentPlayingItemIndex ?? 0
    }
    
    func playItem(at indexPath: Int) {
        guard let item = item(at: indexPath) else { return }
        if item.queues {
            playerService.queue(url: item.audioURL)
            if currentPlayingItemIndex == nil {
                currentPlayingItemIndex = indexPath
            }
        } else {
            if let index = currentPlayingItemIndex {
                playlistItemsService.setStatus(for: index, status: .stopped)
                reloadContent?(.item(IndexPath(row: index, section: 0)))
                currentPlayingItemIndex = nil
            }
            playerService.play(url: item.audioURL)
            currentPlayingItemIndex = indexPath
        }
    }
}

extension PlayerViewModel: AudioPlayerServiceDelegate {
    func statusChanged(status: AudioPlayerState) {
        guard let item = currentPlayingItemIndex else { return }

        switch status {
        case .bufferring:
            playlistItemsService.setStatus(for: item, status: .buffering)
            reloadContent?(.item(IndexPath(item: item, section: 0)))
        case .playing:
            playlistItemsService.setStatus(for: item, status: .playing)
            reloadContent?(.item(IndexPath(item: item, section: 0)))
        case .paused:
            playlistItemsService.setStatus(for: item, status: .paused)
            reloadContent?(.item(IndexPath(item: item, section: 0)))
        case .stopped:
            playlistItemsService.setStatus(for: item, status: .stopped)
            reloadContent?(.item(IndexPath(item: item, section: 0)))
        default:
            break
        }
    }

    func errorOccurred(error _: AudioPlayerError) {
        currentPlayingItemIndex = nil
    }

    func metadataReceived(metadata _: [String: String]) {}
    func didStopPlaying() {}

    func didStartPlaying() {}
}
