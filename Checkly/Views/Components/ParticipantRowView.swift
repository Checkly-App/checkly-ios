//
//  ParticipantRow.swift
//  Checkly
//
//  Created by a w on 11/03/2022.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct ParticipantRowView: View {
    
    @Binding var selectedRows: Set<attendee>
    @Binding var attendeesDictionary: [String:String]
    
    var isSelected: Bool {
        selectedRows.contains(attendee)
    }
    var attendee: attendee
    
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
                    .font(.callout)
                    .foregroundColor(.gray)
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
                // this means that the member exists in selectedRows set, so we are going to remove it
                // and the user selected and unselected the row at the same time
                self.selectedRows.remove(attendee)
                attendeesDictionary["\(attendee.id)"] = "absent"
            } else {
                // Get selected attendee
                selectedRows.insert(attendee)
                // insert into attendees dictionary as 'attended'
                 attendeesDictionary["\(attendee.id)"] = "attended"
                
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
        }
   }
    
}

struct ParticipantRow_Previews: PreviewProvider {
    
    @State static private var attendeesDictionary = ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"accepted" ,"xCITUcFuCodx9SRM4CZPSWi3o2j1":"accepted"]
    
    static var previews: some View {
        ParticipantRowView(selectedRows: (.constant(Set<attendee>())), attendeesDictionary: $attendeesDictionary ,attendee: attendee(id: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", name: "Aleen AlSuhaibani", position: "Associate", imgToken: "null", status: "accepted"))
    }
}

