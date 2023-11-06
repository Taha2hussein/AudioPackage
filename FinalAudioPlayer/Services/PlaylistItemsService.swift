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
    var audioURL: URL?
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

    init(id: String ,audioURL: String?, title: String, album: String, artist: String ,genre: String ,status: Status, queues: Bool) {
        self.id = id
        self.title = title
        self.album = album
        self.status = status
        self.queues = queues
        self.artist = artist
        self.genre = genre
        if let audioURL = audioURL {
            self.audioURL = URL(string: audioURL)
        }
    }
}

final class PlaylistItemsService {
    var itemsClosure:(([PlaylistItem])->())?
    private var shuffleEnabled: Bool = false
    private var tempItems: [PlaylistItem] = []
    private var items: [PlaylistItem] = [] {
        didSet {
            print("list items changed")
//            shuffleEnabled ? print("shuffle  enabled") : (tempItems = items)
            itemsClosure?(items)
        }
    }

    var itemsCount: Int {
        items.count
    }

    let protectedItemCount: Int

    init(initialItemsProvider: () -> [PlaylistItem]) {
        protectedItemCount = items.count
    }

    func item(at index: Int) -> PlaylistItem? {
        guard index < items.count else { return nil }
        return items[index]
    }

    func index(for item: PlaylistItem) -> Int? {
        items.firstIndex(of: item)
    }

    func insertItemToQueue(item: PlaylistItem, index: Int) {
        items.insertElement(item, at: index)
        tempItems.insertElement(item, at: index)
    }

    func validateIndex(index: Int) -> Bool{
        guard items.isValidIndex(index) else {
                return false
            }
        return true
    }
    
    func addMediaToQueue(playlistItem: PlaylistItem) {
        items.append(playlistItem)
        tempItems.append(playlistItem)
    }
    
    func addQueue(queue: [PlaylistItem]) {
        items += queue
        tempItems += queue
    }
   
    func updateStreamURL(url: URL, index: Int) {
        items[index].audioURL = url
        tempItems[index].audioURL = url
    }
    
    func removeAllItems() {
        items.removeAll()
        tempItems.removeAll()
    }
    
    func remove(item: PlaylistItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
        
        if let index = tempItems.firstIndex(of: item) {
            tempItems.remove(at: index)
        }
    }
    
    func shuffle(shuffleEnabled: Bool) {
        self.shuffleEnabled = shuffleEnabled
        shuffleEnabled ? items.shuffle() : resetShuffleToOriginalList()
    }
    
    func resetShuffleToOriginalList() {
        items = tempItems
    }
    
    func updateQueu(queue: [PlaylistItem]) {
        items += queue
        tempItems += queue
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
            audioURL: item.audioURL?.absoluteString,
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
