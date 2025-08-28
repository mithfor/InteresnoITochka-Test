//
//  VideoCollectionViewModel.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 28.08.2025.
//

import Foundation

protocol VideoServiceProtocol {
    func fetchVideos() async throws -> [Video]
}

@MainActor
final class VideoCollectionViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let videoService: VideoServiceProtocol
    
    init(videoService: VideoServiceProtocol = MockVideoService()) {
        self.videoService = videoService
        loadVideos()
    }
    
    func loadVideos() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let loadedVideos = try await videoService.fetchVideos()
                self.videos = loadedVideos
                self.isLoading = false
            } catch {
                self.error = error
                self.isLoading = false
                
                // Fallback to sample videos
                self.videos = Video.videos
            }
        }
    }
    
    func refresh() {
        loadVideos()
    }
    
}

struct MockVideoService: VideoServiceProtocol {
    func fetchVideos() async throws -> [Video] {
        // Simulate network delay
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return Video.videos
    }
    
    
}

