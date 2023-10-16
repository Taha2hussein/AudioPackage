//
//  ViewController.swift
//  FinalAudioPlayer
//
//  Created by A on 29/08/2023.
//

import UIKit
import AVFoundation
import AudioStreaming
class ViewController: UIViewController {
    
    let abstractPlayer = AbstractPlayer.shared
    let playlist1 = PlaylistItem(id: "id", audioURL: "", title: "old", album: "huse", artist: "TjT", genre: "ee", status: .stopped, queues: false)
    
    let playlist2 = PlaylistItem(id: "id2", audioURL: "", title: "new1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
    
    let playlist3 = PlaylistItem(id: "id3", audioURL: "", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
    
    
    let playlist4 = PlaylistItem(id: "id4", audioURL: "", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
    override func viewDidLoad() {
        super.viewDidLoad()
        abstractPlayer.addMediaToQueue(playlist1)
        abstractPlayer.addMediaToQueue(playlist2)
        abstractPlayer.addMediaToQueue(playlist3)
        abstractPlayer.addMediaToQueue(playlist4)
    }
    
    
    @IBAction func updateQueueAction(_ sender: Any) {
        // remove list
        abstractPlayer.removeAll()
        // using add queue again and play in normal case
        abstractPlayer.addMediaToQueue(playlist1)
        abstractPlayer.addMediaToQueue(playlist2)
        
        abstractPlayer.addMediaToQueue(playlist3)
    }
    
    /// here in cancel we remove player and then add play list again
    @IBAction func cancelAction(_ sender: Any) {
        abstractPlayer.cancel()
        
    }
    /// should cancel player and start again
    @IBAction func shuffleAction(_ sender: Any) {
        abstractPlayer.shuffle()
    }
    
    @IBAction func resumeAction(_ sender: Any) {
        abstractPlayer.resume()
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        abstractPlayer.pause()
    }
    
    ///   /// skip to index  after remove queu and add audio to queu
    @IBAction func playAction(_ sender: Any) {
        
        self.abstractPlayer.updateStreamURL(url: URL(string: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 0)
        
        self.abstractPlayer.updateStreamURL(url: URL(string: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3")!, index: 1)
        
        self.abstractPlayer.updateStreamURL(url: URL(string: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 2)
    }
    
    /// skip to index after remove queue
    @IBAction func play1Action(_ sender: Any) {
        self.abstractPlayer.play(url: URL(string: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 0)
        
    }
    /// do as play1 action
    @IBAction func nextAction(_ sender: Any) {
        //        self.abstractPlayer.play(url: URL(string: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 3)
    }
    /// do as play1 action
    @IBAction func prevAction(_ sender: Any) {
        //        self.abstractPlayer.play(url: URL(string: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 3)
        
    }
    
    @IBAction func seekAction(_ sender: Any) {
        abstractPlayer.seek(action: .ended)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        let playlist3 =  PlaylistItem(id: "i6d", audioURL: "", title: "new1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        abstractPlayer.removeMedia(playlist3)
    }
    
    @IBAction func localFileAction(_ sender: Any) {
        abstractPlayer.playLocalFile(file: "hipjazz", ofType: "wav", index: 0)
    }
    
    @IBAction func insetAction(_ sender: Any) {
        let playlist3 = PlaylistItem(id: "idinserted", audioURL: "", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        abstractPlayer.insetMedia(playlist3, index: 1)
    }
    
    @IBAction func eqalizerAction(_ sender: Any) {
        abstractPlayer.intialzeEqalizer()
        let navigationController = UINavigationController(rootViewController: EqualizerViewController(viewModel: abstractPlayer.eqalizerViewModel!))
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}

