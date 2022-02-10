//
//  EditprofileeView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 09/07/1443 AH.
//

import SwiftUI

struct EditprofileeView: View {
    @State private var email = ""
    var body: some View {

        VStack(alignment: .leading) {
            
            Section(header:
                        Text("European Cars")){
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                TextField("Placeholder", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)


            }
            Section(header:
                        Text("European Cars").foregroundColor(.gray).padding(.top)){
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                TextField("Placeholder", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)


            }
                        
        }.padding()
    }
}

struct EditprofileeView_Previews: PreviewProvider {
    static var previews: some View {
        EditprofileeView()
    }
}
