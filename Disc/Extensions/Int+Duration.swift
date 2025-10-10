//
//  Int+Duration.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

import Foundation

extension Int {
    var formattedDuration: String {
        let totalSeconds = self / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
