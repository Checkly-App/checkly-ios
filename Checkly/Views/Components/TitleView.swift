//
//  TitleView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 04/02/2022.
//

import SwiftUI

struct TitleView: View {
    var title: String
    var subTitle: String
    var description: String

    var body: some View {
        HStack(alignment: .top) {
            VStack (alignment: .leading, spacing: 25.0) {
                VStack(alignment: .leading, spacing: 5.0){
                    Text(title)
                        .font(.system(size: 36.0))
                        .foregroundColor(Color(UIColor(named: "DeepBlue")!))
                    Text(subTitle)
                        .font(.system(size: 40.0, weight: .bold))
                        .foregroundColor(Color(UIColor(named: "Navy")!))
                }
                Text(description)
                    .font(.body)
                    .foregroundColor(Color(UIColor(named: "DeepBlue")!))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}
