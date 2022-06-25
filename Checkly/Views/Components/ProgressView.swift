//
//  ProgressView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 16/06/2022.
//

import SwiftUI

// MARK: - Progress View
struct CircularProgressView: View {
    // MARK: - @Binding
    @Binding var progress: Float
    @Binding var degree: Double
    
    // MARK: - Variables
    var color: Color = .accentColor
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .opacity(0.20)
                .foregroundColor(Color("light-gray"))
            Circle()
                .trim()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: degree))
                .animation(.easeInOut(duration: 0.3), value: progress)
                .animation(.linear(duration: 0.2), value: degree)
        }
    }
}

