//
//  GenerateMeetingView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 17/07/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImageSwiftUI

struct GenerateMeetingView1: View {
    @State var sattendencelist0 =  Set<Employee>()

    var body: some View {
        ZStack{
            GenerateMeetingView()
        }
    }}

struct GenerateMeetingView: View {
  
    @Environment(\.dismiss) var dismiss
    @State var title = ""
    @State var location = ""
    @State var starttime0 = ""
    @State var endtime0 = ""

    @State var selectrow = Set<Employee>()
@State var attendeneslist: [Employee] = []
  //  @State var attendeeslist = [Employee]()

    @State var text = ""
    @State var type = ""
     var ref = Database.database().reference()
    
    let userid = Auth.auth().currentUser!.uid
@State var Isselectattendense = false
    @State var isSelectedinline = true
    @State var IsSelectedSite = false
    @State var presentAlert = false
    @State var error0 = "All Feilds are required"
    
    @State var IsitONsite = false
    @State  var date = Date()
    @State  var now = Date()

    @State  var starttime = Date()
    @State  var endtime = Date()+60
   @State var viewlist = false
    @State var viewlist1 = false
    @ObservedObject  var viewModel = EmployeeViewModel()

   @State var attendenceID: [String: String] = [:]

    var body: some View {
        NavigationView{
        VStack{
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                TextField("type title of the meeting", text: $title)
                    .autocapitalization(.none)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .stroke(title.isEmpty ?
                                        Color(UIColor(named: "LightGray")!) :
                                            Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                    .foregroundColor(title.isEmpty ?
                                     Color(UIColor(named: "LightGray")!) :
                                        Color(UIColor(named: "Blue")!))
            }
            .padding().padding(.top)
            .animation(.default)
            VStack(alignment: .leading) {
                Text("Location")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                TextField("type the location", text: $location)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .stroke(location.isEmpty ?
                                        Color(UIColor(named: "LightGray")!) :
                                            Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                    .foregroundColor(location.isEmpty ?
                                     Color(UIColor(named: "LightGray")!) :
                                        Color(UIColor(named: "Blue")!))
            }
            .padding(.horizontal)
            .animation(.default)
            VStack(alignment: .leading){
                HStack{
                Text("Date:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                
                  DatePicker(
                        "Start Date",
                        selection: $date,
                        in: Date.now..., displayedComponents: [.date]
                  ).labelsHidden().fixedSize().frame(maxWidth: .infinity/2,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.white.opacity(0.4))
                    
                }
            }.padding()
            VStack(alignment: .leading){
                HStack(){
                    HStack{
                Text("Start time:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                    
                    DatePicker(
                          "Start time",
                          selection: $starttime,
                          in: Date.now..., displayedComponents: [.hourAndMinute]
                    ).labelsHidden().padding(.trailing).fixedSize().frame(maxWidth: .infinity/2,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.white.opacity(0.4))}
                    HStack{
                    Text("End time:")
                        .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                        
                        DatePicker(
                              "Start time",
                              selection: $endtime,
                              in: Date.now..., displayedComponents: [.hourAndMinute]
                        ).labelsHidden().fixedSize().frame(maxWidth: .infinity/2.5,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.white.opacity(0.4))   .accentColor(.orange)
                    }
                }
              
               .padding(.horizontal)
                
                VStack(alignment:.leading){
                    Text("Agenda")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                    CustomTextEditor.init(placeholder: "enter meeting agenda", text: $text)
                        .font(.body).foregroundColor(text.isEmpty ?
                                                      Color(UIColor(named: "LightGray")!) :
                                                         Color(UIColor(named: "Blue")!))
                                           
                                           .accentColor(.cyan)
                                           .frame(height: 100)
                                           .cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                                        .stroke(text.isEmpty ?
                                                                                Color(UIColor(named: "LightGray")!) :
                                                                                    Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                                                            .foregroundColor(text.isEmpty ?
                                                                             Color(UIColor(named: "LightGray")!) :
                                                                                Color(UIColor(named: "Blue")!))
                }
                .padding(.horizontal)
                VStack(alignment:.leading){
                    Text("Type")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                    HStack {
                        
                     
                        Button(action: {
                             isSelectedinline = true
                            IsitONsite = false

                            IsSelectedSite = false
                            type = "Online"
                        }) {
                            HStack {
                                
                                Text("Online")
                                    .fontWeight(.semibold)
                                    .font(.caption)
                            }
                            .padding()
                            .foregroundColor(isSelectedinline ? .cyan:.gray)
                            .background(isSelectedinline ? .cyan.opacity(0.20):.gray.opacity(0.20))
                            .cornerRadius(90)
                        }
                        Button(action: {
                            isSelectedinline = false
                           IsSelectedSite = true
                            IsitONsite = true
                            type = "On-site"
                            DatePicker(
                                  "Start Date",
                                  selection: $date,
                                  in: Date.now..., displayedComponents: [.date]
                            ).labelsHidden().datePickerStyle(.graphical)
                        }) {
                            HStack {
                           
                                Text("On-site")
                                    .fontWeight(.semibold)
                                    .font(.caption)
                            }
                            .padding()
                            .foregroundColor(IsSelectedSite ? .cyan:.gray)
                            .background(IsSelectedSite ? .cyan.opacity(0.20):.gray.opacity(0.20))
                            .cornerRadius(90)
                            
                        }

                    }

            
                }
                .padding(.horizontal)
                if IsitONsite {
                VStack(alignment:.leading){
                    Text("Select locatin")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                    HStack {
                        
                     
                        Button(action: {
                            viewlist1 = true
                }) {
                            HStack {
                              
                                Text("Select location")
                                    .foregroundColor(.cyan)
                                    .font(.body)
                                    .padding().background(.cyan.opacity(0.20)).cornerRadius(40)
                                    
                        }
                }
                    }
                    
                }
                .padding(.horizontal)
                }
            
                VStack(alignment:.leading){
                    Text("Attendees")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                    HStack{
                    HStack(spacing: -10){
                        if Isselectattendense {
                            if (attendeneslist.count > 4) {         ForEach(1...4, id: \.self) { row in

                                if attendeneslist[row].tokens == "null"{
                                        Image(systemName: "person.circle.fill").resizable() .foregroundColor(Color("LightGray")).frame(width: 50,height: 50)}
                                    else {
                                        WebImage(url:URL(string: attendeneslist[row].tokens)).resizable().frame(width: 50,height: 50).clipShape(Circle())
                                    }



                            }
                                Text("+\(attendeneslist.count-4)").foregroundColor(Color.white).frame(width: 50,height: 50).clipShape(Circle()).background(.black.opacity(0.80)).cornerRadius(40)
                            }
                            else {
                        ForEach(attendeneslist, id: \.self) { emp in
                            if emp.tokens == "null"{
                                Image(systemName: "person.circle.fill").resizable() .foregroundColor(Color("LightGray")).frame(width: 50,height: 50)}
                            else {
                                WebImage(url:URL(string: emp.tokens)).resizable().frame(width: 50,height: 50).clipShape(Circle())
                            }
                        }

                        }

                        }
                        
                        
                    }
                    HStack {
                        
                     
                        Button(action: {
                            viewlist = true
                        // Isselectattendense = false
                }) {
                            HStack {
                                Image(systemName: "plus")


                            }
                            .padding()
                            .foregroundColor(.gray.opacity(0.7))
                            .background(.white)
                            .border(.gray.opacity(0.7),width: 2)
                            .cornerRadius(25)
                        }
                    }
                }
                }
                .padding(.horizontal)
            
            }
            Spacer()
            VStack(alignment: .trailing){
            Button {
                if !validate(){
                   presentAlert = true
                }
                else {
                    Generate() }
               // print("the maon view")
//print(selectrow)
              //  print(self.settings.score)

            }
                label: {
                HStack{
                    Text("Save")
                        .foregroundColor(Color("Blue"))
                    Circle().fill(
                        LinearGradient(gradient: Gradient(colors: [
                            Color(UIColor(named: "Blue")!),
                            Color(UIColor(named: "LightTeal")!)]),
                                       startPoint: .leading, endPoint: .trailing)).frame(width: 50, height: 50).overlay(Image(systemName: "chevron.right").foregroundColor(.white)    .font(.largeTitle)
)
                    
                } .sheet(isPresented: $viewlist, content: {
                    AttendenceListViewselect(selectrow: $selectrow, selectatt: $Isselectattendense, attendeneslist: $attendeneslist)
                })
                }.sheet(isPresented: $viewlist1, content: {
                  LocationMeetingView()
                })
            }.alert("Oops!..", isPresented: $presentAlert, actions: {
                // actions
            }, message: {
                Text(error0)
            })
            .padding(.leading,200)
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
    
    func Generate(){
       
        for attendeneslist in attendeneslist {
            
            attendenceID[attendeneslist.id] = "Not"

        }
        print(attendenceID)
        let calender = Calendar.current
        let datecomp = calender.dateComponents([.day,.month,.year], from: date)
        let timecomp = calender.dateComponents([.hour,.minute,.second], from: starttime)
        var newcomponent = DateComponents()
        newcomponent.timeZone = TimeZone(secondsFromGMT: 0)
        newcomponent.day = datecomp.day
        newcomponent.month = datecomp.month
        newcomponent.year = datecomp.year
        newcomponent.hour = timecomp.hour
        newcomponent.minute = timecomp.minute
        newcomponent.second = timecomp.second
        let newintervaldate = calender.date(from: newcomponent)
        print(newintervaldate)
            //        let testdate = date.formatted(.dateTime.month().day().year())
        let interval = newintervaldate!.timeIntervalSinceNow
        print(interval)
        print(title)
        print(location)
        print(text)
        print(starttime.formatted(.dateTime.hour().minute().second()))
        starttime0 = starttime.formatted(.dateTime.hour().minute().second())
      endtime0 = endtime.formatted(.dateTime.hour().minute().second())
        print(endtime.formatted(.dateTime.hour().minute().second()))
        print(type)
//        ref.child("Meetings").childByAutoId().setValue(["title": title,"agenda": text,"host":userid,"location":location,"type":type,"date":interval,"start_time":starttime0,"end_time":endtime0,"attendees":attendenceID,"latitude":title,"longitude":title
//                                                            ])





        

    }
    
    func validate()-> Bool{
        starttime0 = starttime.formatted(.dateTime.hour().minute())
        var hourin =  starttime0.prefix(2)
        
              if hourin.suffix(1) == ":"
              {
                  hourin = hourin.prefix(1)

             }
        var minuted = starttime.formatted(.dateTime.minute())
        let AmOrPM = starttime0.suffix(2)
        
        print(AmOrPM)
        print(hourin)
        print(minuted)
        
        /// end time
      endtime0 = endtime.formatted(.dateTime.hour().minute())
        var endhour =  endtime0.prefix(2)
        
              if endhour.suffix(1) == ":"
              {
                  endhour = endhour.prefix(1)

             }
        var minutedend = endtime.formatted(.dateTime.minute())
        let AmOrPMEnd = endtime0.suffix(2)
        
        print(AmOrPMEnd)
        print(endhour)
        print(minutedend)
       if AmOrPMEnd == "AM" && AmOrPM == "PM"
        {
           return false
       }
        if AmOrPMEnd == AmOrPM {
        if endhour == hourin {
          if  minutedend <= minuted{
                return false
            }
        }else
            if endhour < hourin{
            return false
        }
        }
        
 
        if title == ""{
            return false }
        if location == "" {
            return false }
        if text == "" {
            return false }
        if attendeneslist.count == 0{
            return false 
        }
     
            
        return true
    }
                                        }
                                        
                                        
                                        

struct CustomTextEditor: View {
    let placeholder: String
    @Binding var text: String
    let internalPadding: CGFloat = 5
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty  {
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(internalPadding)
            }
            TextEditor(text: $text)
                .padding(internalPadding)
        }.onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear() {
            UITextView.appearance().backgroundColor = nil
        }
    }
}
 

struct GenerateMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateMeetingView()
    }
}
