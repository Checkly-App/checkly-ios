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
            VisualEffect(effect: UIBlurEffect(style: .regular))
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(named: "Green")!)))
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
        uiView.backgroundColor = UIColor(named: "LightBlue")!.withAlphaComponent(0.5)
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
