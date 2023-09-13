//
//  Valiadtion.swift
//  FinalAudioPlayer
//
//  Created by Taha Hussein on 11/09/2023.
//

import Foundation
extension Array {
    mutating func insertElement(_ element: Element, at index: Int) {
        if index >= 0 && index <= count {
            insert(element, at: index)
        } else {
          }
    }
}
