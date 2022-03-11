//
//  ParticipantRow.swift
//  calendar
//
//  Created by a w on 11/03/2022.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct ParticipantRow: View {
    
    var attendee: attendee
    
    @Binding var selectedRows: Set<attendee>
    
    var isSelected: Bool {
        selectedRows.contains(attendee)
    }
    
    var body: some View {

        HStack {
            
            // attendee image
            if URL(string: attendee.imgToken) == URL(string: "null"){
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                } else {
                    WebImage(url: URL(string: attendee.imgToken))
                        .resizable()
                        .indicator(Indicator.activity)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .onAppear(perform: {loadImageFromFirebase(imgurl: attendee.imgToken)})
                }
                
            VStack(alignment: .leading, spacing: 5){
                // attendee name
                Text(attendee.name)
                    .font(.system(size: 20, weight: .medium))
                // attendee position
                Text(attendee.position)
                    .font(.system(size: 14))
                }
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // display check mark when the row is selected
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? Color("BlueA") : .gray)
                .imageScale(.large)
            
        }
        .padding()
        .onTapGesture {
            if isSelected{
                self.selectedRows.remove(attendee)
            } else {
                selectedRows.insert(attendee)
            }
        }
        
    }
    
    func loadImageFromFirebase(imgurl: String) {
       let storage = Storage.storage().reference(forURL: imgurl)
       storage.downloadURL { (url, error) in
       if error != nil {
           print((error?.localizedDescription)!)
           return
           }
           print("Download success")
           }
   }
    
}

struct ParticipantRow_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantRow(attendee: attendee(id: "e0a6ozh4A0QVOXY0tyiMSFyfL163", name: "Aleen AlSuhaibani", position: "Associate", imgToken: "null", status: "accepted"), selectedRows: (.constant(Set<attendee>())))
    }
}

