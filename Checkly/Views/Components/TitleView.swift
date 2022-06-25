//
//  TitleView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 04/02/2022.
//
import SwiftUI

struct TitleView: View {
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .top) {
            VStack (alignment: .center, spacing: 15.0) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("coal"))
                Text(description)
                    .font(.body)
                    .foregroundColor(Color("coal"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
