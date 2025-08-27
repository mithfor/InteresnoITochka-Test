//
//  VideoPlayerView.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 27.08.2025.
//
import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    let video: Video
    
    @StateObject private var viewModel: VideoPlayerViewModel
    @State private var isPlaying = false
    
    init(video: Video) {
        self.video = video
        
        _viewModel = StateObject(wrappedValue: VideoPlayerViewModel(url: video.url))
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                VideoPlayer(player: viewModel.player)
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
//                OverlayedTextView(videoTitle: video.title)
                
            }
            .onAppear(perform: {
                play()
            })
            .onChange(of: geo.frame(in: .global).midY) { _, newValue in
                let screenHeight = UIScreen.main.bounds.height
                
                var isVisible: Bool {
                    abs(newValue - screenHeight / 2) < screenHeight / 2
                }
                
                if isVisible && isPlaying {
                    play()
                } else if !isVisible && isPlaying {
                    pause()
                }
            }
        }
    }
    
    private func play() {
        viewModel.player.play()
        isPlaying = true
    }
    
    private func pause() {
        viewModel.player.pause()
        isPlaying = false
    }
}
