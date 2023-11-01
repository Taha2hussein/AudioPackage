//
//  AbstractPlayer.swift
//  FinalAudioPlayer
//
//  Created by Taha Hussein on 30/08/2023.
//

import UIKit
import AudioStreaming
enum Status {
    case next
    case previous
}

protocol PlayerProtocol {
    var playlistItemsService: PlaylistItemsService { get set}
    var viewModel: PlayerViewModel { get set }
    var service: AudioPlayerService { get set }
    var eqalizerViewModel: EqualzerViewModel? { get set }
    var PlayerControls: PlayerControlsViewModel  { get set }
    var minimumPlaybackDuration: TimeInterval { get set }
    var currentIndex: Int { get set }
    func seek(action: SeekAction)
    func play(url: URL, index: Int)
    func playLocalFile(file: String, ofType: String, index: Int)
    func skipToQueueItem(index: Int)
    func update(gain: Float, for index: Int)
    func checkEqalizerEnabled() -> Bool
    func enableEq(_ enable: Bool)
    func updateStreamURL(url: URL, index: Int)
    func repeatAudio(repeatMode: RepeatMode)
    func removeAll()
    func shuffle()
    func next()
    func previous()
    func pause()
    func resume()
    func cancel()
    
}

protocol PlayerListProtocol {
    func queue(urlsAbsoulteString: [String])
    func addQueue(_ listItems: [PlaylistItem])
    func extractURLFromPlayListItemsAndADDToQueue(listItems: [PlaylistItem])
    func getItemsList() -> [PlaylistItem]
    func getCurrentQueueCount() -> Int
    func insetMedia(_ playlistItem: PlaylistItem , index: Int)
    func removeMedia(_ playlistItem: PlaylistItem)
    func addMediaToQueue(_ playlistItem: PlaylistItem)
}
protocol sharedPlayerProtocol: PlayerProtocol,PlayerListProtocol {}

class AbstractPlayer : sharedPlayerProtocol {
    var currentIndex: Int = 0
    var minimumPlaybackDuration: TimeInterval = 5.0
    static let shared = AbstractPlayer()
    var PlayerControls: PlayerControlsViewModel
    var eqalizerViewModel: EqualzerViewModel?
    var playlistItemsService = PlaylistItemsService(initialItemsProvider: provideInitialPlaylistItems)
    var service = AudioPlayerService()
    var viewModel: PlayerViewModel
    private var repeatMode: RepeatMode = .none
    init() {
        viewModel = PlayerViewModel(playlistItemsService: playlistItemsService, playerService: service)
        PlayerControls = PlayerControlsViewModel(playerService: service)
        intialzeEqalizer()
    
        service.stateClosure = { state in
            print(state)
        }
        
        service.urlClosure = {[weak self] url in
           
            let items = self?.getItemsList()
            
            let selectedIndices = items?.enumerated()   // Pair-up elements and their offsets
                .filter { url.contains($0.element.audioURL?.absoluteString ?? "") }  // Get the ones you want
                .map { $0.offset }

            self?.service.currentIndex?(selectedIndices?[0] ?? 0)
        }
        
        service.currentIndex = { [weak self] index in
            self?.currentIndex = index
            print(index ,"current playing index")
        }
        
        service.finishPlaying = {[weak self] in
            self?.repeatPlaying()
            print("repaet status")
        }
        
        playlistItemsService.itemsClosure = {[weak self] item in
            print(item , "item closure")
        }
    }

    internal func intialzeEqalizer() {
        let equaliserService = EqualizerService(playerService: service)
        eqalizerViewModel = EqualzerViewModel(equalizerService: equaliserService)
        let _ = EqualizerViewController(viewModel: eqalizerViewModel!)
    }
    
    func checkEqalizerEnabled() -> Bool {
        return eqalizerViewModel?.equaliserIsOn ?? false
    }
    
    func enableEq(_ enable: Bool) {
        eqalizerViewModel?.enableEq(enable)
    }
    
    ///  just used with local files
    internal func play(url: URL, index: Int) {
        playlistItemsService.updateStreamURL(url: url, index: index)
    }
    
    func playLocalFile(file: String, ofType: String, index: Int) {
        if let path = Bundle.main.path(forResource: file, ofType: ofType) {
            let url = URL(fileURLWithPath: path)
            updateStreamURL(url: url, index: index)
        }
    }
    
    func skipToQueueItem(index: Int) {
        let validatedIndex = playlistItemsService.validateIndex(index: index)
        if validatedIndex == true {
            currentIndex = index
            viewModel.playItem(at: index)
        }
    }
    
    func queue(urlsAbsoulteString: [String]) {
        urlsAbsoulteString.forEach() { abosulteString in
            if let url = URL(string: abosulteString) {
                service.queue(url: url)
            }
        }
    }
    
    func update(gain: Float, for index: Int) {
        eqalizerViewModel?.update(gain: gain, for: index)
    }
    
    func repeatAudio(repeatMode: RepeatMode) {
        self.repeatMode = repeatMode
    }
    
    func repeatPlaying() {
        switch repeatMode {
        case .none: break
        case .all:
            if currentIndex == viewModel.itemsCount - 1 {
                self.skipToQueueItem(index: 0)
            }
        case .one:
            self.skipToQueueItem(index: viewModel.getCurrentPlayingIndex())
        }
    }
    
    func next() {
        switch repeatMode {
        case .none, .all :
            let nextIndex = changeIndexDependOnStatus(status: .next)
            self.skipToQueueItem(index: nextIndex)
        case .one:
            self.seek(action: .ended)
        }
    }
    
    func previous() {
        switch repeatMode {
        case .none, .all :
            let nextIndex = changeIndexDependOnStatus(status: .previous)
            self.skipToQueueItem(index: nextIndex)
        case .one:
            self.seek(action: .ended)
        }
    }
    
    func changeIndexDependOnStatus(status: Status) -> Int {
//        currentIndex = viewModel.getCurrentPlayingIndex()
        let validationIndex = validateIndex(index: currentIndex , status: status)
        if validationIndex {
            switch status {
            case .next :
                currentIndex = currentIndex + 1
            case .previous :
                currentIndex = currentIndex - 1
            }
        }
        return currentIndex
    }
    
    func validateIndex(index: Int , status: Status) -> Bool {
        var validatorBool: Bool = false
        switch status {
        case .next:
            validatorBool = (index >= 0 && index < viewModel.itemsCount)
        case .previous:
            validatorBool = (index > 0 && index < viewModel.itemsCount)
        }
        return  validatorBool
    }
    
    func shuffle() {
        playlistItemsService.shuffleAudioList()
    }
    
    func pause() {
        PlayerControls.togglePauseResume()
    }
    
    func resume() {
        PlayerControls.togglePauseResume()
    }
    
    func cancel() {
        PlayerControls.stop()
    }
    
    func removeAll() {
        playlistItemsService.removeAllItems()
    }
    
    func updateStreamURL(url: URL, index: Int) {
        playlistItemsService.updateStreamURL(url: url, index: index)
        service.queue(url: url)
    }
    
    func addQueue(_ listItems: [PlaylistItem]) {
        playlistItemsService.addQueue(queue: listItems)
    }
    
    func extractURLFromPlayListItemsAndADDToQueue(listItems: [PlaylistItem]) {
        listItems.forEach() { playItem in
            if let url: URL = playItem.audioURL as? URL {
                service.queue(url: url)
            }
        }
    }
    
    func getItemsList() -> [PlaylistItem] {
        return playlistItemsService.getItemsList()
    }
    
    func getCurrentQueueCount() -> Int {
        return playlistItemsService.itemsCount
    }
    
    func seek(action: SeekAction) {
        PlayerControls.seek(action: action)
    }
    
    func insetMedia(_ playlistItem: PlaylistItem, index: Int) {
        playlistItemsService.insertItemToQueue(item: playlistItem,index:  index)
    }
    
    func addMediaToQueue(_ playlistItem: PlaylistItem) {
        playlistItemsService.addMediaToQueue(playlistItem: playlistItem)
    }
    
    func removeMedia(_ playlistItem: PlaylistItem) {
        playlistItemsService.remove(item: playlistItem)
    }
}
