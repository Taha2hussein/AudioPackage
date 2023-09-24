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
