//
//  Utility.swift
//  FinalAudioPlayerTests
//
//  Created by Taha Hussein on 20/09/2023.
//

import Foundation
import SwiftUI
import XCTest

class Utility: MockerProtocols {
    func loadMockJSONData(fileName: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: fileName, ofType: "json") else {
            XCTFail("MockData.json file not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch {
            XCTFail("Error loading mock JSON data: \(error)")
            return nil
        }
    }
}
