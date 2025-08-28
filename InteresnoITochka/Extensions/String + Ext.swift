//
//  String + Ext.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 28.08.2025.
//

import Foundation

extension String {
    func timeString(from seconds: Double) -> Self {
        guard seconds.isFinite else { return "0.00" }
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%d:%0.2d", minutes, seconds)
    }
}
