//
//  Array + Extension.swift
//  FinalAudioPlayer
//
//  Created by Taha Hussein on 24/09/2023.
//

import UIKit
extension Array {
    func isValidIndex(_ index : Int) -> Bool {
        return index < self.count
    }
}
extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
