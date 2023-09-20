//
//  FinalAudioPlayerTests.swift
//  FinalAudioPlayerTests
//
//  Created by Taha Hussein on 31/08/2023.
//

import XCTest
@testable import FinalAudioPlayer

final class FinalAudioPlayerTests: XCTestCase {
    var songPlayer: AbstractPlayer?
    var mocking: Utility?
    let expectation = XCTestExpectation(description: "Song playback completed")
    
    override func setUp() {
        super.setUp()
        songPlayer = AbstractPlayer.shared
        mocking = Utility()
    }
    
    override func tearDown() {
        songPlayer = nil
        super.tearDown()
    }
    
    func testMainPlayer() {
        // Given
        songPlayer?.playLocalFile(file: "hipjazz", ofType: "wav")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.songPlayer?.pause()
            // Assuming the song duration is longer than 2 seconds, check if the player is playing
            XCTAssertTrue(self.songPlayer?.service.state == .paused, "Song should be paused")
            self.expectation.fulfill()
        }
        
        songPlayer?.playLocalFile(file: "hipjazz", ofType: "wav")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.songPlayer?.service.state == .playing, "Song should be playing")
            self.expectation.fulfill()
        }
        
        songPlayer?.playLocalFile(file: "hipjazz", ofType: "wav")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.songPlayer?.cancel()
            // Assuming the song duration is longer than 2 seconds, check if the player is playing
            XCTAssertTrue(self.songPlayer?.service.state == .stopped, "Song should be Disposed")
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        
    }
    
    func testAddQueueFromBackEnd() {
        let playlist1 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist2 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.songPlayer?.addQueue([playlist1,playlist2])
            
            XCTAssertTrue(self.songPlayer?.playlistItemsService.itemsCount == 2, "items Array should be 2")
            self.expectation.fulfill()
        }
        //        self.expectation.fulfill()
        
    }
    
    func testEqualizer() {
        // Given
        let frequencies: [Float] = [32, 64, 128, 250, 500, 1000, 2000, 4000, 8000, 16000]
        
        songPlayer?.enableEq(true)
        
        for(index, element ) in frequencies.enumerated() {
            songPlayer?.update(gain: element, for: index)
        }
        
        XCTAssertEqual(songPlayer?.eqalizerViewModel?.returnedBands.count, 10 , "Equalizer frequencies should match")
        XCTAssertEqual(songPlayer?.checkEqalizerEnabled() , true , "eqalizer should not enabled ")
    }
    
    func testNextAudio() {
        let playlist1 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist2 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist3 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        songPlayer?.addQueue([playlist1,playlist2,playlist3])
        songPlayer?.skipToQueueItem(index: 0)
        let currentAudio = songPlayer?.currentIndex ?? 0
        XCTAssertEqual(currentAudio, 0, "Next audio not played correctly.")
        
        songPlayer?.next()
        let currentAudio1 = songPlayer?.currentIndex ?? 0
        // 5. Assert that the current audio is the second audio
        XCTAssertEqual(currentAudio1, 1, "Next audio not played correctly.")
        
        // 6. Call the nextAudio() method again
        songPlayer?.next()
        let currentAudio2 = songPlayer?.currentIndex ?? 0
        // 7. Assert that the current audio is the third audio
        XCTAssertEqual(currentAudio2, 2, "Next audio not played correctly.")
    }
    
    func testPreviousAudio() {
        let playlist1 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist2 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist3 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        songPlayer?.addQueue([playlist1,playlist2,playlist3])
        songPlayer?.skipToQueueItem(index: 0)
        songPlayer?.next()
        songPlayer?.next()
        songPlayer?.previous()
        let currentAudio = songPlayer?.currentIndex ?? 0
        // 7. Assert that the current audio is the third audio
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            XCTAssertEqual(currentAudio, 1, "Next audio not played correctly.")
            self.expectation.fulfill()
        }
    }
    
    func testSeek() {
        songPlayer?.playLocalFile(file: "hipjazz", ofType: "wav")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.songPlayer?.seek(action: .ended)
            let currentTime = self.songPlayer?.service.progress
            XCTAssertEqual(currentTime, 0.0, "player sould play at second 0")
            self.expectation.fulfill()
        }
    }
    
    func testSkip() {
        let playlist1 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist2 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist3 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        songPlayer?.addQueue([playlist1,playlist2,playlist3])
        songPlayer?.skipToQueueItem(index: 2)
        let currentAudio = songPlayer?.currentIndex ?? 0
        XCTAssertEqual(currentAudio, 2, "Next audio not played correctly.")
    }
    
    func testshuffle() {
        let playlist1 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist2 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist3 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        songPlayer?.addQueue([playlist1,playlist2,playlist3])
        let songList = songPlayer?.getItemsList()
        songPlayer?.shuffle()
        let shuffledList = songPlayer?.getItemsList()
        XCTAssertNotEqual(songList, shuffledList, "shuffled performed correctly")
        
    }
    
    func testAddMediaToQueue() {
        let playlist1 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist2 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        songPlayer?.addQueue([playlist1,playlist2])
        let songsCount = songPlayer?.getCurrentQueueCount()
        XCTAssertEqual(songsCount, 2, "media queue should be two")
        
        
        let playlist3 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        songPlayer?.addMediaToQueue(playlist3)
        let songsCountAfterAdding = songPlayer?.getCurrentQueueCount()
        XCTAssertEqual(songsCountAfterAdding, 3, "media added to queue correectly")
        
    }
    
    func testUpdateQueue() {
        let playlist1 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        let playlist2 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.songPlayer?.addQueue([playlist1,playlist2])
            let songsCount = self.songPlayer?.getCurrentQueueCount()
            XCTAssertEqual(songsCount, 2, "media queue should be two")
            
            
            let playlist3 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
            
            let playlist4 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_00099.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
            self.songPlayer?.addQueue([playlist3,playlist4])
            
            let songsCountAfterUpdate = self.songPlayer?.getCurrentQueueCount()
            XCTAssertEqual(songsCountAfterUpdate, 4, "queue  updated correectly")
            self.expectation.fulfill()
        }
    }
    
    func testParsingMockJSON() {
        // Load mock JSON data
        guard let jsonData = mocking?.loadMockJSONData(fileName: "Mock") else {
            XCTFail("Failed to load mock JSON data")
            return
        }
        
        do {
            // Parse the JSON data
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // Assert the expected structure or values in the JSON array
            if let jsonArray = jsonArray as? [[String: Any]] {
                XCTAssertEqual(jsonArray.count, 10)
                
                let firstObject = jsonArray[0]
                XCTAssertEqual(firstObject["entryId"] as? String, "13223671")
               
                
                let secondObject = jsonArray[1]
                XCTAssertEqual(secondObject["entryId"] as? String, "11535932")
             
            } else {
                XCTFail("Invalid JSON structure")
            }
        } catch {
            XCTFail("Error parsing mock JSON: \(error)")
        }
    }
    
    
    //    func testInsertMedial() {
    //        let playlist1 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
    //
    //        let playlist2 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    //            self.songPlayer?.addQueue([playlist1,playlist2])
    //
    //            XCTAssertTrue(self.songPlayer?.playlistItemsService.itemsCount == 2, "items Array should be 2")
    //
    //            let playlist3 = PlaylistItem(id: "id", audioURL: "https://ms18.sm3na.com/140/Sm3na_com_69335.mp3", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
    //
    //            self.songPlayer?.insetMedia(playlist3, index: 2)
    //            XCTAssertTrue(self.songPlayer?.playlistItemsService.itemsCount == 3, "items Array should be 2")
    //
    //            self.expectation.fulfill()
    //        }
    //    }
    
}
