//
//  LoadingView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 04/02/2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15.0)
                .fill(Color(UIColor(named: "Loading")!))
                .frame(width: 200, height: 200)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(named: "Green")!)))
                .scaleEffect(1.5)
        }
    }
}

