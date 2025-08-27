//
//  Video.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 27.08.2025.
//
import Foundation

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
