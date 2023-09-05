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
    let expectation = XCTestExpectation(description: "Song playback completed")

    override func setUp() {
        super.setUp()
        songPlayer = AbstractPlayer()
    }
    
    override func tearDown() {
        songPlayer = nil
        super.tearDown()
    }
    
    func testPlaySong() {
        // Given
        songPlayer?.playLocalFile(file: "hipjazz", ofType: "wav")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Assuming the song duration is longer than 2 seconds, check if the player is playing
            XCTAssertTrue(self.songPlayer?.service.state == .playing, "Song should be playing")
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
    }
    
    func testPauseSong() {
        // Given
        songPlayer?.playLocalFile(file: "hipjazz", ofType: "wav")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.songPlayer?.pause()
            // Assuming the song duration is longer than 2 seconds, check if the player is playing
            XCTAssertTrue(self.songPlayer?.service.state == .paused, "Song should be paused")
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
        
    }
    
    func testAddQueueFromBackEnd() {
        let playlist1 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/67b51d90ffddd6bb3f095059997021b589845f81?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)

        let playlist2 = PlaylistItem(id: "id", audioURL: "https://p.scdn.co/mp3-preview/081447adc23dad4f79ba4f1082615d1c56edf5e1?cid=d8a5ed958d274c2e8ee717e6a4b0971d", title: "TA1", album: "huse", artist: "TT", genre: "ee", status: .stopped, queues: false)
        
        songPlayer?.addQueue([playlist1,playlist2])
        
        XCTAssertTrue(self.songPlayer?.playlistItemsService.itemsCount == 2, "items Array should be 2")
            self.expectation.fulfill()
        
        wait(for: [expectation], timeout: 3)
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
}
