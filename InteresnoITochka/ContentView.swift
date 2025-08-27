//
//  ContentView.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 27.08.2025.
//

import AVKit
import SwiftUI

struct Video: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
    
    
    static let videos: [Video] =
    [
        Video(title: "Video 1",
              url: URL(string: "https://interesnoitochka.ru/api/v1/videos/video/25/hls/playlist.m3u8")!
             ),
        Video(title: "Video 2",
              url: URL(string: "https://interesnoitochka.ru/api/v1/videos/video/1/hls/playlist.m3u8")!
             ),
        Video(title: "Video 3",
              url: URL(string: "https://interesnoitochka.ru/api/v1/videos/video/3/hls/playlist.m3u8")!
             )
    ]
}

class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
//        self.player.isMuted = true
    }
}

struct ContentView: View {
    

    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 5) {
                ForEach(videos) { video in
                    VideoPlayerView(video: video)
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
                        .clipped()
                }
                
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ContentView()
}

 

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

struct OverlayedTextView: View {
    
    let videoTitle: String
    
    var body: some View {
        Text(videoTitle)
            .font(.title2)
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .backgroundStyle(.black.opacity(0.5))
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            }
            .padding(.bottom, 20)
    }
}
