//
//  AbstractPlayer.swift
//  FinalAudioPlayer
//
//  Created by Taha Hussein on 30/08/2023.
//

import Foundation

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
    func play(url: URL)
    func playLocalFile(file: String, ofType: String)
    func playAtIndex(index: Int)
    func update(gain: Float, for index: Int)
    func checkEqalizerEnabled() -> Bool
    func enableEq(_ enable: Bool)
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
    func insetMedia(_ playlistItem: PlaylistItem)
    func removeMedia(_ playlistItem: PlaylistItem)
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
    
    init() {
        viewModel = PlayerViewModel(playlistItemsService: playlistItemsService, playerService: service)
        PlayerControls = PlayerControlsViewModel(playerService: service)
        intialzeEqalizer()
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
    
    internal func play(url: URL) {
        viewModel.playItem(with: url)
    }
    
    func playLocalFile(file: String, ofType: String) {
        if let path = Bundle.main.path(forResource: file, ofType: ofType) {
            let url = URL(fileURLWithPath: path)
            play(url: url)
            
        }
    }
    
    func playAtIndex(index: Int) {
        currentIndex = index
        viewModel.playItem(at: index)
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
    
    func next() {
        let index =  changeIndexDependOnStatus(status: .next)
        playAtIndex(index:  index)
    }
    
    func previous() {
        if service.progress <= minimumPlaybackDuration {
            self.playAtIndex(index: currentIndex)
             return
         }
        let index = changeIndexDependOnStatus(status: .previous)
        playAtIndex(index:  index)
    }
    
    func changeIndexDependOnStatus(status: Status) -> Int {
         currentIndex = viewModel.getCurrentPlayingIndex()
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
    
    func pause() {
        PlayerControls.togglePauseResume()
    }
    
    func resume() {
        PlayerControls.togglePauseResume()
    }
    
    func cancel() {
        PlayerControls.stop()
    }
    
    func addQueue(_ listItems: [PlaylistItem]) {
        playlistItemsService.addQueue(queue: listItems)
        extractURLFromPlayListItemsAndADDToQueue(listItems: listItems)
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
    
    func insetMedia(_ playlistItem: PlaylistItem) {
        playlistItemsService.add(item: playlistItem)
        
    }
    
    func removeMedia(_ playlistItem: PlaylistItem) {
        playlistItemsService.remove(item: playlistItem)
    }
}
