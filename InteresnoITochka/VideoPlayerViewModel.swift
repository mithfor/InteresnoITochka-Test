//
//  VideoPlayerViewModel.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 27.08.2025.
//
import SwiftUI
import AVKit

class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
//        self.player.isMuted = true
    }
}
