//
//  MeetingAttendeesListView.swift
//  Checkly
//
//  Created by a w on 04/03/2022.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct MeetingAttendeesListView: View {
    
    @ObservedObject var meetingViewModel : MeetingViewModel = MeetingViewModel()
    var meeting: Meeting
    
    var body: some View {
       
        VStack {
            Rectangle()
                .fill(.gray)
                .frame(width: 38, height: 5)
                .cornerRadius(35)
                .padding(.top, 10)
            
            VStack(alignment: .leading) {
                
                Text("Attendees")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                List(meetingViewModel.meetingAttendeesArray(meeting: meeting)){ attendee in
                  
                    HStack(spacing: 10){
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
                        }
                        .frame(height: 60)
                    }
                .listStyle(.plain)
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

struct MeetingAttendeesListView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingAttendeesListView(meeting: Meeting(id: "11", host: "none", title: "none", date: Date(), type: "Online", location: "none", attendees: ["12":"accepted"], agenda: "lorem ipsum", end_time: "9:30 AM", start_time: "9:30 AM", latitude: "unavailable", longitude: "unavailable"))
    }
}
