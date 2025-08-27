//
//  OverlayedTextView.swift
//  InteresnoITochka
//
//  Created by Dmitrii Voronin on 27.08.2025.
//
import SwiftUI

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
