//
//  PrivacyAndPolicyView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 23/07/1443 AH.
//

import SwiftUI

struct PrivacyAndPolicyView: View {
    var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 40){
                Image(systemName: "lock.shield")
                    .resizable()
                    .frame(width: 70, height: 80, alignment: .leading)
                Text("Privacy And Policy")
                    .bold()
                    .font(.system(size: 30))
                ScrollView(showsIndicators: true){
                    Text("We may collect information about you in a variety of ways. The information we may collect via the Application depends on the content and materials you use, and includes:Personal Data Demographic and other personally identifiable information (such as your name and email address) that you voluntarily give to us when choosing to participate in various activities related to the Application. If you choose to share data about yourself via your profile, online chat, or other interactive areas of the Application, please be advised that all data you disclose in these areas is private and your data will be accessible to government authorities. Geo-Location Information We may request access or permission to and track location-based information from your mobile device, either continuously or while you are using the Application, to provide location-based services. If you wish to change our access or permissions, you may do so in your device’s settings.")
                        .baselineOffset(16)
                }
            }
            .padding(24)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .fixedSize(horizontal: true, vertical: false)
        }
    }
}

struct PrivacyAndPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyAndPolicyView()
    }
}
