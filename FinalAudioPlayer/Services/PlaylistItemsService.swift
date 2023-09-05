//
//  PlaylistItemsService.swift
//  FinalAudioPlayer
//
//  Created by Taha Hussein on 30/08/2023.
//

import Foundation

struct PlaylistItem: Equatable {
    enum Status: Equatable {
        case playing
        case paused
        case buffering
        case stopped
    }
    let id: String
    let audioURL: URL
    let title: String
    let album: String
    let status: Status
    let queues: Bool
    let artist: String
    let genre: String
    init(content: AudioContent, queues: Bool) {
        id = ""
        title = content.title
        album = content.subtitle ?? ""
        audioURL = content.streamUrl
        artist = ""
        genre = ""
        status = .stopped
        self.queues = queues
    }

    init(id: String ,audioURL: String, title: String, album: String, artist: String ,genre: String ,status: Status, queues: Bool) {
        self.id = id
        self.audioURL = URL(string: audioURL ?? "")!
        self.title = title
        self.album = album
        self.status = status
        self.queues = queues
        self.artist = artist
        self.genre = genre
    }
}

final class PlaylistItemsService {
    private var items: [PlaylistItem] = []

    var itemsCount: Int {
        items.count
    }

    let protectedItemCount: Int

    init(initialItemsProvider: () -> [PlaylistItem]) {
//        items = initialItemsProvider()
        protectedItemCount = items.count
    }

    func item(at index: Int) -> PlaylistItem? {
        guard index < items.count else { return nil }
        return items[index]
    }

    func index(for item: PlaylistItem) -> Int? {
        items.firstIndex(of: item)
    }

    func add(item: PlaylistItem) {
        items.append(item)
    }

    func addQueue(queue: [PlaylistItem]) {
        items = queue
    }
    
    func remove(item: PlaylistItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    func updateQueu(queue: [PlaylistItem]) {
        items.removeAll()
        items = queue
    }
    
    func getItemsList() -> [PlaylistItem] {
    return items
    }
    
    func setStatus(for index: Int, status: PlaylistItem.Status) {
        guard let item = item(at: index) else {
            return
        }
        items[index] = PlaylistItem(
            id: item.id,
            audioURL: item.audioURL.absoluteString,
            title: item.title,
            album: item.album,
            artist: item.artist,
            genre: item.genre,
            status: status,
            queues: item.queues
        )
    }
}

func provideInitialPlaylistItems() -> [PlaylistItem] {
    let allCases = AudioContent.allCases
    let casesForQueueing: [AudioContent] = [.piano, .local, .khruangbin]
    let allItems = allCases.map { PlaylistItem(content: $0, queues: false) }
    let casesForQueuingItems = casesForQueueing.map { PlaylistItem(content: $0, queues: true) }
    return allItems + casesForQueuingItems
}
