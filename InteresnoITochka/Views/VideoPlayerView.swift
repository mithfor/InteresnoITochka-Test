//
//  VideoPlayerView.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 27.08.2025.
//
import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    struct AppearenceConstants {
        static let videoframeHeight: CGFloat = 250
        static let videoframeCornerRadius: CGFloat = 12
    }
    
    
    @StateObject private var viewModel: VideoPlayerViewModel
    let video: Video
    
    init(video: Video) {
        self.video = video
        _viewModel = StateObject(wrappedValue: VideoPlayerViewModel(video: video))
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
                videoPlayer
                videoInfo
            }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

    }
    
    private var videoPlayer: some View {
        ZStack {
            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .frame(height: AppearenceConstants.videoframeHeight)
                    .cornerRadius(AppearenceConstants.videoframeCornerRadius)
                    .overlay(
                        controlsOverlay
                            .opacity(viewModel.showControls ? 1 : 0)
                            .animation(.easeInOut(duration: 0.2), value: viewModel.showControls)
                    )
                
            } else {
                loadingView
            }
        }
        .onTapGesture {
            viewModel.toggleControls()
        }
    }
    
    private var controlsOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: viewModel.togglePlayPause) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            cornerRadius(8)
        }
        .padding()
    }
    
    private var loadingView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: AppearenceConstants.videoframeHeight)
            .cornerRadius(AppearenceConstants.videoframeCornerRadius)
            .overlay {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading video...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    padding(.top, 8)
                }
            }
    }
    
    private var videoInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(video.title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(video.url.absoluteString)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.horizontal, 4)
    }
}

