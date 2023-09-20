//
//  MockerProtocols.swift
//  FinalAudioPlayerTests
//
//  Created by Taha Hussein on 18/09/2023.
//

import Foundation
protocol MockerProtocols {
    func testJSONParsing<T: Decodable>(jsonFileName: String, responseType: T.Type)
}
