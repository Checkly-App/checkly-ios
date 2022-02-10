//
//  LoadingView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 09/07/1443 AH.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .cyan)).background(RoundedRectangle(cornerRadius: 3, style: .continuous).frame(width: 70, height: 70).foregroundColor(Color("bluesky"))).scaleEffect(3)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
