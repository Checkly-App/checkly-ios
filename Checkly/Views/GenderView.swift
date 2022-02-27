//
//  GenderView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 11/07/1443 AH.
//

import SwiftUI

struct GenderView: View {
    @State var isSelectedinline = true
    @State var IsSelectedSite = false

    var body: some View {
        VStack(alignment:.leading){
//            Text("Gender")
//            HStack{
//                HStack{
//                Circle()
//                    .fill(Color.gray.opacity(1))
//                    .frame(width:20, height: 20)
//                Text("Male ")
//            }.overlay(RoundedRectangle(cornerRadius: 5)
//                        .fill(Color.gray.opacity(0.3))
//                        .frame(width: 130, height: 55).foregroundColor(.black).border(.black, width: 0.5).cornerRadius(5)).padding()
//            HStack{
//                Circle()
//                    .fill(Color.gray.opacity(0.25))
//                    .frame(width:20, height: 20)
//                Text("Female")
//            }.overlay(RoundedRectangle(cornerRadius: 5)
//                        .fill(Color.gray.opacity(0.3))
//                        .frame(width: 130, height: 55).border(.black, width: 0.5).cornerRadius(5)).padding(.leading).padding(.leading).padding(.leading)
//            }
//
//        }
//    }
//            HStack{
//                Text("Online").padding(.all).overlay(RoundedRectangle(cornerRadius: 200, style: .continuous).stroke(Color.gray, lineWidth: 3))
//                Text("On-site").padding(.all).overlay(RoundedRectangle(cornerRadius: 200, style: .continuous).stroke(Color.gray, lineWidth: 3))
//
//            }
            HStack {
                
             
                Button(action: {
                     isSelectedinline = true
                    IsSelectedSite = false                }) {
                    HStack {
                        
                        Text("Online")
                            .fontWeight(.semibold)
                            .font(.body)
                    }
                    .padding()
                    .foregroundColor(isSelectedinline ? .cyan:.gray)
                    .background(isSelectedinline ? .cyan.opacity(0.20):.gray.opacity(0.20))
                    .cornerRadius(90)
                }
                Button(action: {
                    isSelectedinline = false
                   IsSelectedSite = true                  }) {
                    HStack {
                        
                        Text("On-site")
                            .fontWeight(.semibold)
                            .font(.body)
                    }
                    .padding()
                    .foregroundColor(IsSelectedSite ? .cyan:.gray)
                    .background(IsSelectedSite ? .cyan.opacity(0.20):.gray.opacity(0.20))
                    .cornerRadius(90)
                }

            }

    }
}
}

struct GenderView_Previews: PreviewProvider {
    static var previews: some View {
        GenderView()
    }
}
