//
//  AudioPlayerService.swift
//  FinalAudioPlayer
//
//  Created by Taha Hussein on 30/08/2023.
//

import AudioStreaming
import AVFoundation
import Combine
protocol AudioPlayerServiceDelegate: ObservableObject ,AnyObject {
    func didStartPlaying()
    func didStopPlaying()
    func statusChanged(status: AudioPlayerState)
    func errorOccurred(error: AudioPlayerError)
    func metadataReceived(metadata: [String: String])
}

class AudioPlayerService {
    var delegate = MulticastDelegate<any AudioPlayerServiceDelegate>()
    var stateClosure: ((AudioPlayerState)->Void)?
    var urlClosure: ((String)->Void)?
    var currentIndex: ((Int)->Void)?
    var finishPlaying:(()->())?
    private var player: AudioPlayer
    private var audioSystemResetObserver: Any?
    
    var duration: Double {
        player.duration
    }
    
    var progress: Double {
        player.progress
    }
    
    var isMuted: Bool {
        player.muted
    }
    
    var state: AudioPlayerState {
        player.state
    }
    
    var rate: Float {
        player.rate
    }
    
    var volume: Float {
        player.volume
    }
    
    var muted: Bool {
        player.muted
    }
    
    init() {
        player = AudioPlayer(configuration: .init(enableLogs: true))
        player.delegate = self
        configureAudioSession()
        registerSessionEvents()
    }
    
    func play(url: URL) {
        activateAudioSession()
        player.play(url: url)
    }
    
    func queue(url: URL) {
        activateAudioSession()
        player.queue(url: url)
    }
    
    func stop() {
        player.stop()
        deactivateAudioSession()
    }
    
    func pause() {
        player.pause()
    }
    
    func resume() {
        player.resume()
    }
    
    func toggleMute() {
        player.muted = !player.muted
    }
    
    func updateRate(rate: Float) {
        player.rate = rate
    }
    
    func updateVolume(value: Float) {
        player.volume = value
    }
    
    func add(_ node: AVAudioNode) {
        player.attach(node: node)
    }
    
    func remove(_ node: AVAudioNode) {
        player.detach(node: node)
    }
    
    func toggle() {
        if player.state == .paused {
            player.resume()
        } else {
            player.pause()
        }
    }
    
    func seek(at time: Float) {
        player.seek(to: Double(time))
    }
    
    private func recreatePlayer() {
        player = AudioPlayer(configuration: .init(enableLogs: true))
        player.delegate = self
    }
    
    private func registerSessionEvents() {
        // Note that a real app might need to observer other AVAudioSession notifications as well
        audioSystemResetObserver = NotificationCenter.default.addObserver(forName: AVAudioSession.mediaServicesWereResetNotification,
                                                                          object: nil,
                                                                          queue: nil) { [unowned self] _ in
            self.configureAudioSession()
            self.recreatePlayer()
        }
    }
    
    private func configureAudioSession() {
        do {
            print("AudioSession category is AVAudioSessionCategoryPlayback")
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(0.1)
        } catch let error as NSError {
            print("Couldn't setup audio session category to Playback \(error.localizedDescription)")
        }
    }
    
    private func activateAudioSession() {
        do {
            print("AudioSession is active")
            try AVAudioSession.sharedInstance().setActive(true, options: [])
            
        } catch let error as NSError {
            print("Couldn't set audio session to active: \(error.localizedDescription)")
        }
    }
    
    private func deactivateAudioSession() {
        do {
            print("AudioSession is deactivated")
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error as NSError {
            print("Couldn't deactivate audio session: \(error.localizedDescription)")
        }
    }
}

extension AudioPlayerService: AudioPlayerDelegate {
    func audioPlayerDidStartPlaying(player _: AudioPlayer, with audioEntry: AudioEntryId) {
        delegate.invoke(invocation: { $0.didStartPlaying() })
        urlClosure?(audioEntry.id)
        print("urlClosure sdf")
    }
    
    func audioPlayerDidFinishBuffering(player _: AudioPlayer, with _: AudioEntryId) {}
    
    func audioPlayerStateChanged(player _: AudioPlayer, with newState: AudioPlayerState, previous _: AudioPlayerState) {
        stateClosure?(newState)
        print("newStatess")
        delegate.invoke(invocation: { $0.statusChanged(status: newState) })
    }
    
    func audioPlayerDidFinishPlaying(player _: AudioPlayer,
                                     entryId audioEntry: AudioEntryId,
                                     stopReason _: AudioPlayerStopReason,
                                     progress _: Double,
                                     duration _: Double)
    {
        print("Finished")
        delegate.invoke(invocation: { $0.didStopPlaying() })
        finishPlaying?()
    }
    
    func audioPlayerUnexpectedError(player _: AudioPlayer, error: AudioPlayerError) {
        delegate.invoke(invocation: { $0.errorOccurred(error: error) })
    }
    
    func audioPlayerDidCancel(player _: AudioPlayer, queuedItems _: [AudioEntryId]) {}
    
    func audioPlayerDidReadMetadata(player _: AudioPlayer, metadata: [String: String]) {
        delegate.invoke(invocation: { $0.metadataReceived(metadata: metadata) })
    }
}
