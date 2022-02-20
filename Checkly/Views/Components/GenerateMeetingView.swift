//
//  GenerateMeetingView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 17/07/1443 AH.
//

import SwiftUI

struct GenerateMeetingView: View {
    @Environment(\.dismiss) var dismiss
    @State var email = ""
    @State private var date = Date()

    var body: some View {
        NavigationView{
        VStack{
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                TextField("type your email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .stroke(email.isEmpty ?
                                        Color(UIColor(named: "LightGray")!) :
                                            Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                    .foregroundColor(email.isEmpty ?
                                     Color(UIColor(named: "LightGray")!) :
                                        Color(UIColor(named: "Blue")!))
            }
            .padding().padding(.top)
            .animation(.default)
            VStack(alignment: .leading) {
                Text("Location")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                TextField("type your email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .stroke(email.isEmpty ?
                                        Color(UIColor(named: "LightGray")!) :
                                            Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                    .foregroundColor(email.isEmpty ?
                                     Color(UIColor(named: "LightGray")!) :
                                        Color(UIColor(named: "Blue")!))
            }
            .padding(.horizontal)
            .animation(.default)
            VStack(alignment: .leading){
                Text("Date")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                DatePicker(
                      "Start Date",
                      selection: $date,
                      in: Date.now..., displayedComponents: [.date]
                ).labelsHidden().fixedSize().frame(maxWidth: .infinity,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.gray.opacity(0.4))
            }.padding()
            VStack(alignment: .leading){
                HStack(spacing:130){
                Text("Start time")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                    .padding(.leading)
                   
                    Text("End time")
                        .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))}
                HStack{
                DatePicker(
                      "Start time",
                      selection: $date,
                      in: Date.now..., displayedComponents: [.hourAndMinute]
                ).labelsHidden().padding(.horizontal).fixedSize().frame(maxWidth: 220,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.gray.opacity(0.4))
            
                DatePicker(
                      "Start time",
                      selection: $date,
                      in: Date.now..., displayedComponents: [.hourAndMinute]
                ).labelsHidden().fixedSize().frame(maxWidth: .infinity/2,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.gray.opacity(0.4))
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Agenda")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor(named: "LightGray")!))

                    TextField("type your email", text: $email)
                        .frame(height: 200.0)
                        .autocapitalization(.none)
                        .padding(10).lineLimit(5)
                        .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .stroke(email.isEmpty ?
                                            Color(UIColor(named: "LightGray")!) :
                                                Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                        .foregroundColor(email.isEmpty ?
                                         Color(UIColor(named: "LightGray")!) :
                                            Color(UIColor(named: "Blue")!))
                }
                .padding(.horizontal)
                .animation(.default)
            }
            Spacer()
        }.navigationBarTitle("Generate Meeting").toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                           dismiss()
                       } label: {
                           HStack{
                Image(systemName: "chevron.left")
                               Text("Back").foregroundColor(Color("Blue"))
                           }

                       }
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
    }
                                        }
                                        
                                        
                                        

                                        

struct GenerateMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateMeetingView()
    }
}
