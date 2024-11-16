//
//  GifView.swift
//  Loft
//
//  Created by Mae on 11/15/24.
//

import SwiftUI

struct GifView: View {
    let frames: [String]
    private let framesPerSecond = 5.0
    
    private var frameInterval: TimeInterval {
        1.0 / (framesPerSecond * Double(frames.count))
    }
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: frameInterval)) { context in
            let frameIndex = Int((context.date.timeIntervalSince1970 * framesPerSecond).truncatingRemainder(dividingBy: Double(frames.count)))
            Image(frames[frameIndex])
                .resizable()
                .scaledToFit()
                .accessibilityLabel("Animated GIF")
        }
    }
}

#Preview {
    GifView(frames: ["Bot1", "Bot2", "Bot3"])
}
