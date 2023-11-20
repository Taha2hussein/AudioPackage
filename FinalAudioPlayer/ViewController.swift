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
    
    @IBOutlet weak var progressSlider: ProgressSlider!
    @IBOutlet weak var repatLabel: UILabel!
    
    let abstractPlayer = AbstractPlayer.shared
    let playlist1 = PlaylistItem(id: "id", audioURL: "", title: "111", album: "huse", artist: "1111", genre: "ee", status: .stopped, queues: false,cover: "https://www.gstatic.com/webp/gallery3/1.sm.png")
    
    let playlist2 = PlaylistItem(id: "id2", audioURL: "", title: "222", album: "huse", artist: "2222", genre: "ee", status: .stopped, queues: false, cover: "https://via.placeholder.com/150/0000FF/808080?Text=PAKAINFO.com")
    
    let playlist3 = PlaylistItem(id: "3333", audioURL: "", title: "333", album: "huse", artist: "333", genre: "ee", status: .stopped, queues: false, cover: "https://via.placeholder.com/150/FF0000/FFFFFF?Text=yttags.com")
    
    
    let playlist4 = PlaylistItem(id: "id4", audioURL: "", title: "444", album: "huse", artist: "4444", genre: "ee", status: .stopped, queues: false, cover: "https://via.placeholder.com/150/FFFF00/000000?Text=google.com")
    override func viewDidLoad() {
        super.viewDidLoad()
        abstractPlayer.addMediaToQueue(playlist1)
        abstractPlayer.addMediaToQueue(playlist2)
        abstractPlayer.addMediaToQueue(playlist3)
        abstractPlayer.addMediaToQueue(playlist4)
        
        // progress slider
        abstractPlayer.playerControls.updateBuffer = {[weak self] buffer in
            self?.progressSlider.progress = Float(buffer)
             
        }
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
        abstractPlayer.shuffle(shuffleEnabled: true)
    }
    
    @IBAction func nonShuffleAction(_ sender: Any) {
        abstractPlayer.shuffle(shuffleEnabled: false)

    }
    
    @IBAction func resumeAction(_ sender: Any) {
        abstractPlayer.resume()
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        abstractPlayer.pause()
    }
    
    ///   /// skip to index  after remove queu and add audio to queu
    @IBAction func playAction(_ sender: Any) {
        
        self.abstractPlayer.play(url: URL(string: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 0)
        
        self.abstractPlayer.play(url: URL(string: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3")!, index: 1)
        
        self.abstractPlayer.play(url: URL(string: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 2)
        
        self.abstractPlayer.play(url: URL(string: "https://p.scdn.co/mp3-preview/cab4b09c23ffc11774d879977131df9d150fcef4?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 3)
        self.abstractPlayer.skipToQueueItem(index: 0)

    }
    
    /// skip to index after remove queue
    @IBAction func play1Action(_ sender: Any) {
        self.abstractPlayer.play(url: URL(string: "https://www.kozco.com/tech/piano2-CoolEdit.mp3")!, index: 3)
        self.abstractPlayer.skipToQueueItem(index: 3)
        
    }
    /// do as play1 action
    @IBAction func nextAction(_ sender: Any) {
        abstractPlayer.next()
//        self.abstractPlayer.play(url: URL(string: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 3)
    }
    /// do as play1 action
    @IBAction func prevAction(_ sender: Any) {
        abstractPlayer.previous()
//        self.abstractPlayer.play(url: URL(string: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d")!, index: 3)
        
    }
    
    @IBAction func NoRepeatAction(_ sender: Any) {
        abstractPlayer.repeatAudio(repeatMode: .none)
        repatLabel.text = "None"
    }
    
    @IBAction func repeat1Action(_ sender: Any) {
        abstractPlayer.repeatAudio(repeatMode: .one)
        repatLabel.text = "One"
    }
    
    @IBAction func repeatAllAction(_ sender: Any) {
        abstractPlayer.repeatAudio(repeatMode: .all)
        repatLabel.text = "All"
    }
    
    @IBAction func seekAction(_ sender: Any) {
        abstractPlayer.seek(action: .ended)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        let playlist1 = PlaylistItem(id: "id", audioURL: "", title: "old", album: "huse", artist: "TjT", genre: "ee", status: .stopped, queues: false, cover: "https://via.placeholder.com/150/000000/FFFFFF/?text=y2meta.com")
        abstractPlayer.removeMedia(playlist1)
    }
    
    @IBAction func localFileAction(_ sender: Any) {
        abstractPlayer.playLocalFile(file: "hipjazz", ofType: "wav", index: 0)
    }
    
    @IBAction func insetAction(_ sender: Any) {
        let playlist3 = PlaylistItem(id: "idinserted", audioURL: "", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false, cover: "https://www.kasandbox.org/programming-images/avatars/spunky-sam.png")
        abstractPlayer.insetMedia(playlist3, index: 1)
    }
    
    @IBAction func eqalizerAction(_ sender: Any) {
        abstractPlayer.intialzeEqalizer()
        let navigationController = UINavigationController(rootViewController: EqualizerViewController(viewModel: abstractPlayer.eqalizerViewModel!))
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    @IBAction func muteAction(_ sender: Any) {
        abstractPlayer.toggleMute()
    }
    
    @IBAction func unMuteAction(_ sender: Any) {
        abstractPlayer.toggleMute()

    }
    @IBAction func rateAction(_ sender: UISlider) {
        abstractPlayer.updateRate(value: Double(sender.value))

    }
    @IBAction func volumeAction(_ sender: UISlider) {
        abstractPlayer.updateVolume(value: Double(sender.value))
    }
    
}

