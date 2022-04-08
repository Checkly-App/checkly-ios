//
//  GenerateMoMView.swift
//  calendar
//
//  Created by a w on 05/04/2022.
//

import SwiftUI

struct GenerateMoMView: View {
    
    @ObservedObject var meetingViewModel : MeetingViewModel = MeetingViewModel()
    @Environment(\.dismiss) var dismiss
    // for Decisions text area
    @FocusState private var isfocus : Bool
    @State var text = ""
    // get passed meeting object
    var meeting: Meeting
    @State private var showingAlert = false
    
    
    var body: some View {
        NavigationView{
            VStack {
                ScrollView{
                        VStack(alignment: .leading, spacing: 10){
                            
                            VStack(alignment: .leading, spacing: 5) {
                                    Text("Title")
                                        .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                                    // fetch Title
                                    Text(meeting.title)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                }

                            
                            VStack(alignment: .leading, spacing: 5) {
                                    Text("Host")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                                    // fetch host name
                                    Text(meetingViewModel.getHostName(hostID: meeting.host))
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                }

                            VStack(alignment: .leading, spacing: 5){
                                    Text("Location")
                                        .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                                    // fetch Type & Location
                                Text("\(meeting.type), \(meeting.location)")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                }

                            HStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 5){
                                    Text("Date")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                                    // fetch Date
                                    Text(meeting.datetime_start.formatted(date: .abbreviated, time: .omitted))
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                }
                                VStack(alignment: .leading, spacing: 5){
                                    Text("Time")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                                    // fetch Time
                                    Text("\(meeting.datetime_start.formatted(date: .omitted, time: .shortened)) - \(meeting.datetime_end.formatted(date: .omitted, time: .shortened))")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                }
                            }
                            
                            // Attended Participants
                            if meetingViewModel.getAttendedParticipants(meeting: meeting).count == 0 {
                                Text("Present")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                                Text("No participant has attended the meeting")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            else {
                                VStack(alignment: .leading, spacing: 5){
                                    Text("Present")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                                    // fetch Present Attendees
                                    ForEach(meetingViewModel.getAttendedParticipants(meeting: meeting)){ attendee in
                                            Text(attendee.name)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.black)
                                    }
                                    
                                }
                            }
                            
                            // Absent Participants
                            if meetingViewModel.getAbsentParticipants(meeting: meeting).count == 0{
                                Text("Absent")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                                Text("No absent participants")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            else {
                                VStack(alignment: .leading, spacing: 5){
                                    Text("Absent")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                                    // fetch Absent Attendees
                                    ForEach(meetingViewModel.getAbsentParticipants(meeting: meeting)){ attendee in
                                            Text(attendee.name)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.black)
                                    }
                                }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 5){
                                Text("Agenda")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                                // fetch Agenda
                                Text(meeting.agenda)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            VStack(alignment: .leading){
                                Text("Decisions")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                                CustomTextEditor.init(placeholder: "Enter Decisions", text: $text).focused($isfocus)
                                            .font(.body).foregroundColor(text.isEmpty ?
                                             Color(UIColor(named: "LightGray")!) :
                                             Color(UIColor(named: "Blue")!))
                                            .accentColor(.cyan)
                                            .frame(width: 335,height: 100)
                                            .cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                            .stroke(text.isEmpty ?
                                             Color(UIColor(named: "LightGray")!) :
                                             Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                                            .foregroundColor(text.isEmpty ?
                                             Color(UIColor(named: "LightGray")!) :
                                             Color(UIColor(named: "Blue")!))
                            }
                        }
                        .padding(.leading, 12)
                        .padding(.trailing, 5)
                    }
                    .background(){
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 370, height: 600)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0.1, y: 0.1)
                    }
                    .frame(width: 370, height: 550)
                    .padding(.top, 25)
                
                // SAVE Button
                Button{
                    // validate if decisions not empty
                    if  text == "" {
                        // show alert
                        showingAlert = true
                    } else {
                        // upload meeting decisions to DB
                        meetingViewModel.generateMoM(meeting: meeting, decisions: text)
                        // setting up selected meeting in order to update it
                        meetingViewModel.selectedMeeting = meeting
                        // dismiss the view
                        dismiss()
                    }
                    
                } label: {
                    HStack{
                        Text("Save")
                            .foregroundColor(Color("BlueA"))
                            .fontWeight(.semibold)
                        Circle()
                            .fill(
                                LinearGradient(colors: [Color(red: 0.337, green: 0.729, blue: 0.922),Color(red: 0.275, green: 0.631, blue: 0.953)], startPoint: .bottom, endPoint: .top)
                            )
                            .frame(width: 50, height: 50)
                            .overlay(Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.largeTitle))
                    }
                }
                .padding(.top, 45)
                .padding(.leading, 230)
            }
            
            // Show alert if no decisions were entered
            .alert("Oops..!", isPresented: $showingAlert, actions: {
                // Default Action
            }, message: {
                Text("Decisions field cannot be empty")
            })
            
            .navigationBarTitle("Generate MoM").toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack{
                                Image(systemName: "chevron.left")
                                Text("Back")
                                }
                                .foregroundColor(Color("Blue"))
                            }
                        }
                }
            .navigationBarTitleDisplayMode(.inline).toolbar {
                ToolbarItem(placement: .keyboard){
                    Button{
                        isfocus = false
                    } label: {
                        Text("Done").foregroundColor(Color("Blue"))
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

struct GenerateMoMView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateMoMView(meeting: Meeting(id: "1", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Cloud Security Engineers Meeting", datetime_start: .init(timeIntervalSince1970: TimeInterval(1646892000)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1646893800)),type: "On-site", location: "STC HQ IT Meeting Room", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"absent", "T1yCDgsjayWdDlBq1nd3yp4FFGo2":"attended"], agenda: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna", latitude: "24.7534673", longitude: "46.6920362", decisions: "-"))
    }
}
