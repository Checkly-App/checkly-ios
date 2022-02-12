//
//  GenderView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 11/07/1443 AH.
//

import SwiftUI

struct GenderView: View {
    var body: some View {
        VStack(alignment:.leading){
            Text("Gender")
            HStack{
                HStack{
                Circle()
                    .fill(Color.gray.opacity(1))
                    .frame(width:20, height: 20)
                Text("Male ")
            }.overlay(RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 55).foregroundColor(.black).border(.black, width: 0.5).cornerRadius(5)).padding()
            HStack{
                Circle()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width:20, height: 20)
                Text("Female")
            }.overlay(RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 55).border(.black, width: 0.5).cornerRadius(5)).padding(.leading).padding(.leading).padding(.leading)
            }
            
        }
    }
}

struct GenderView_Previews: PreviewProvider {
    static var previews: some View {
        GenderView()
    }
}
