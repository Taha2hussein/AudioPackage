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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playlist1 = PlaylistItem(id: "id", audioURL: "", title: "old", album: "huse", artist: "TjT", genre: "ee", status: .stopped, queues: false)
        
        let playlist2 = PlaylistItem(id: "i6d", audioURL: "", title: "new1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        
        let playlist3 = PlaylistItem(id: "id", audioURL: "", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        abstractPlayer.addQueue([playlist1,playlist2,playlist3])
    }
    
    
    @IBAction func updateQueueAction(_ sender: Any) {
        abstractPlayer.cancel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            var indec = 0
            print(indec , "dssdsd")
            self.abstractPlayer.updateStreamURL(url: URL(string: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3")!, index: indec)
            
            indec = indec + 1
            print(indec , "dssdsd")
            
            self.abstractPlayer.updateStreamURL(url: URL(string: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: indec)
            print(indec , "dssdsd")
            
        }
    }
    
    /// here in cancel we remove player and then add play list again
    @IBAction func cancelAction(_ sender: Any) {
        abstractPlayer.cancel()
    
    }
    /// should cancel player and start again
    @IBAction func shuffleAction(_ sender: Any) {
        abstractPlayer.cancel()
        abstractPlayer.shuffle()
    }
    
    @IBAction func resumeAction(_ sender: Any) {
        abstractPlayer.resume()
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        abstractPlayer.pause()
    }
    
    @IBAction func playAction(_ sender: Any) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            var indec = 0
            print(indec , "dssdsd")
            self.abstractPlayer.updateStreamURL(url: URL(string: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: indec)
            
            
            indec = indec + 1
            print(indec , "dssdsd")
            
            self.abstractPlayer.updateStreamURL(url: URL(string: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3")!, index: indec)
            print(indec , "dssdsd")
            
        }
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        abstractPlayer.next()
        
    }
    
    @IBAction func prevAction(_ sender: Any) {
        abstractPlayer.previous()
    }
    
    @IBAction func seekAction(_ sender: Any) {
        abstractPlayer.seek(action: .ended)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        let playlist3 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        abstractPlayer.removeMedia(playlist3)
    }
    
    @IBAction func localFileAction(_ sender: Any) {
        abstractPlayer.playLocalFile(file: "hipjazz", ofType: "wav")
        
    }
    
    @IBAction func insetAction(_ sender: Any) {
        let playlist3 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        abstractPlayer.insetMedia(playlist3, index: 1)
    }
    
    @IBAction func palyAtIndexAction(_ sender: Any) {
        abstractPlayer.skipToQueueItem(index: 1)
    }
    
    @IBAction func eqalizerAction(_ sender: Any) {
        abstractPlayer.intialzeEqalizer()
        let navigationController = UINavigationController(rootViewController: EqualizerViewController(viewModel: abstractPlayer.eqalizerViewModel!))
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}

