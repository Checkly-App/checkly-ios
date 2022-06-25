//
//  LoadingView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 04/02/2022.
//
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            VisualEffect(effect: UIBlurEffect(style: .light))
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                .scaleEffect(2)
        }
    }
}

struct VisualEffect: UIViewRepresentable{
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
        uiView.backgroundColor = UIColor(named: "sky-blue")!.withAlphaComponent(0.5)
    }
}

