//
//  TermsAndConditionsView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 23/07/1443 AH.
//

import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 40){
                Image(systemName: "hand.raised")
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .leading)
                Text("Terms And Conditions")
                    .bold()
                    .font(.system(size: 30))
                ScrollView(showsIndicators: true){
                    Text("By using the application, you represent and warrant that: (1) all registration information you submit will be true, accurate, current, and complete. (2) you will maintain the accuracy of such information and promptly update such registration information as necessary. (3) you have the legal capacity and you agree to comply with these Terms of Use. (4) you are not under the age of 12. (5) you will not access the application through automated or non-human means, whether through a bot, script or otherwise. (6) you will not use the application for any illegal or unauthorized purpose; and your use of the application will not violate any applicable law or regulation. If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the application (or any portion thereof).")
                        .baselineOffset(16)
                }
                
            }
            .padding(24)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
    }
}
