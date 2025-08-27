//
//  ContentView.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 27.08.2025.
//

import AVKit
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 5) {
                ForEach(Video.videos) { video in
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
