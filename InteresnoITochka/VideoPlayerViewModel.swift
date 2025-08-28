//
//  VideoPlayerViewModel.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 27.08.2025.
//
import SwiftUI
import AVKit
import Combine

// TODO: Fix MainActor behavior in Swift 6
final class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var isPlaying = false
    @Published var showControls = false
    @Published var isMuted = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var isLoading = true
    @Published var error: Error?
    
    private var video: Video
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    
    init(video: Video) {
        self.video = video
        setupPlayer()
        setupBindings()
    }
    
    deinit {
        cleanup()
    }
    
    // MARK: - Public methods
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if player.rate == 0 {
            play()
        } else {
            pause()
        }
    }
    
    func toggleMute() {
        isMuted.toggle()
        player?.isMuted = isMuted
    }
    
    func toggleControls() {
        showControls.toggle()
    }
    
    func seek(to time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 1000))
    }
    
    // MARK: - Private methods
    
    private func setupPlayer() {
        isLoading = true
        error = nil
        
        player = AVPlayer(url: video.url)
        player?.isMuted = isMuted
        
        setupTimeObserver()
        observePlayerStatus()
    }
    
    private func setupTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main,
            using: { [weak self] time in
                self?.currentTime = time.seconds
                self?.updateDuration()
                self?.updatePlaybackStatus()
            })
    }
    
    private func observePlayerStatus() {
        NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification)
            .sink { [weak self] _ in
                self?.isPlaying = false
                self?.currentTime = 0
                self?.player?.seek(to: .zero)
            }
            .store(in: &cancellables)
    }
    
    private func setupBindings() {
        $player
            .compactMap { $0 }
            .sink { [weak self] player in
                self?.updateDuration()
            }
            .store(in: &cancellables)
    }
    
    private func updateDuration() {
        guard let currentItem = player?.currentItem else {
            duration = 0
            return
        }
        
        let itemDuration = currentItem.duration.seconds
        duration = itemDuration.isNaN ? 0: itemDuration
        
        if duration > 0 && isLoading {
            isLoading = false
        }
    }
    
    private func updatePlaybackStatus() {
        guard let player = player else {
            isPlaying = false
            return
        }
        
        isPlaying = player.rate != 0 && player.error == nil
    }
    
    private func play() {
        player?.play()
        isPlaying = true
    }
    
    private func pause() {
        player?.pause()
        isPlaying = false
    }
    
    private func cleanup() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        
        player?.pause()
        player = nil
        cancellables.removeAll()
    }
}
