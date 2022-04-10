//
//  servicesView.swift
//  Checkly
//
//  Created by Norua Alsalem on 10/04/2022.
//

import SwiftUI

struct servicesView: View {
    var body: some View {
        VStack (alignment: .leading) {
            Text("Sick Leaves/Vacations").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    box(title: "My Requests", image: "doc.on.doc.fill")
                    box(title: "Submit Request", image: "paperplane.fill")
                    box(title: "Approve/Reject", image: "checkmark.circle.fill")
                }.padding()
            }
            Text("Notifications").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    box(title: "Notify Manager", image: "bell.fill")
                    box(title: "View Statuses", image: "bell.badge.fill")
                }.padding()
            }

            Text("Other").bold()
            ScrollView (.horizontal, showsIndicators: false) {
                HStack{
                    box(title: "Generate Meeting", image: "plus.circle.fill")
                    box(title: "public Statements", image: "speaker.fill")
                }.padding()
            }
            Spacer()
        }.padding().navigationTitle("Services").navigationBarTitleDisplayMode(.inline)
    }
}

struct servicesView_Previews: PreviewProvider {
    static var previews: some View {
        servicesView()
    }
}

struct box: View {

    var title: String
    var image: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Image(systemName: image).foregroundColor(Color(red: 0.173, green: 0.694, blue: 0.937))
            Spacer()
            Text(title).bold()
        }.padding().frame(width: 130, height: 120).background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(color: .gray, radius: 0.5, x: 0.5, y: 0.5))
    }
}
