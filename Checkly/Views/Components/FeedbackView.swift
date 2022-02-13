//
//  LoadingView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 04/02/2022.
//

import SwiftUI

struct FeedbackView: View {
    var imageName: String
    var title: String
    var message: String
    
    var body: some View {
        ZStack {
            VisualEffect(effect: UIBlurEffect(style: .light))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            VStack (spacing: 15){
                Image(systemName: imageName)
                    .font(.system(size: 48, weight: .medium))
                VStack(alignment: .center, spacing: 5) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                    Text(message)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14, weight: .medium))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    
                }
            }
            .foregroundColor(.accentColor)
        }
        .frame(width: 220, height: 220)
    }
}


struct Feedback_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView(imageName: "xmark", title: "Success", message: "Check your inbox for a reset message")
    }
}
