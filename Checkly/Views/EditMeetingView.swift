
import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImageSwiftUI
import MapKit


struct EditMeetingView: View {
    
    @State  var locations: [Mark] = []
    @Environment(\.dismiss) var dismiss
    @State var title = ""
    @State var isAtend = 1
    @State var starttime0 = ""
    @State var endtime0 = ""
    @State var Address_pic = "Select Location"
    @FocusState private var isfocus : Bool
    @State var selectrow = Set<Employee>()
    @State var attendeneslist: [Employee] = []
    var meeting : Meeting
    @State var text = ""
    @State var type = "Online"
    var ref = Database.database().reference()
    @StateObject var locationManager = LocationManager.shared
    let userid = Auth.auth().currentUser!.uid
    @State var Isselectattendense = true
    @State var isSelectedinline = true
    @State var Isshow = true
    @State var isselectADD = false
    @State var oldAddress = ""
    @State var presentAlert = false
    @State var error0 = "All Feilds are required"
    @State  var now = Date()
    @State  var starttime = Date()
    @State  var endtime = Date()+60
    @State var viewlist = false
    @State var viewlist1 = false
    @ObservedObject  var viewModel = EmployeeViewModel()
    @State var attendenceID: [String: String] = [:]
   
    var body: some View {
        NavigationView{
            ScrollView {
        VStack{
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                TextField("type title of the meeting", text: $viewModel.MeetingObj.title)
                    .autocapitalization(.none)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .stroke(viewModel.MeetingObj.title.isEmpty ?
                                        Color(UIColor(named: "LightGray")!) :
                                            Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                    .foregroundColor(viewModel.MeetingObj.title.isEmpty ?
                                     Color(UIColor(named: "LightGray")!) :
                                        Color(UIColor(named: "Blue")!))
            }
            .padding().padding(.top)
            .animation(.default)
            VStack(alignment: .leading) {
                Text("Location")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                TextField("type the location", text: $viewModel.MeetingObj.location).focused($isfocus)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .stroke(viewModel.MeetingObj.location.isEmpty ?
                                        Color(UIColor(named: "LightGray")!) :
                                            Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                    .foregroundColor(viewModel.MeetingObj.location.isEmpty ?
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
                        selection: $viewModel.MeetingObj.datetime_start,
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
                    // TIME
                    DatePicker(
                          "Start time",
                          selection:$viewModel.MeetingObj.datetime_start,
                          in: Date.now..., displayedComponents: [.hourAndMinute ]
                    ).labelsHidden().padding(.trailing).fixedSize().frame(maxWidth: .infinity/2,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.white.opacity(0.4)).environment(\.timeZone, TimeZone(abbreviation: "GMT+3")!)}
                    HStack{
                    Text("End time:")
                        .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                        
                        DatePicker(
                              "End time",
                              selection: $viewModel.MeetingObj.datetime_end,
                              in: Date.now..., displayedComponents: [.hourAndMinute]
                        ).labelsHidden().fixedSize().frame(maxWidth: .infinity/2.5,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.white.opacity(0.4))
                    }
                }
              
               .padding(.horizontal)
                
                VStack(alignment:.leading){
                    Text("Agenda")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                    CustomTextEditor.init(placeholder: "enter meeting agenda", text: $viewModel.MeetingObj.agenda).focused($isfocus)
                        .font(.body).foregroundColor(viewModel.MeetingObj.agenda.isEmpty ?
                                                      Color(UIColor(named: "LightGray")!) :
                                                         Color(UIColor(named: "Blue")!))
                                           
                                           .accentColor(.cyan)
                                           .frame(height: 100)
                                           .cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                                        .stroke(viewModel.MeetingObj.agenda.isEmpty ?
                                                                                Color(UIColor(named: "LightGray")!) :
                                                                                    Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                                                            .foregroundColor(viewModel.MeetingObj.agenda.isEmpty ?
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
                            viewModel.isSelectedinline = true
                            viewModel.IsSelectedSite = false

                            viewModel.isonsite = false
                            type = "Online"
                        }) {
                            HStack {
                                
                                Text("Online")
                                    .fontWeight(.semibold)
                                    .font(.caption)
                            }
                            .padding()
                            .foregroundColor(viewModel.isSelectedinline ? .cyan:.gray)
                            .background(viewModel.isSelectedinline ? .cyan.opacity(0.20):.gray.opacity(0.20))
                            .cornerRadius(90)
                        }
                        Button(action: {
                          
                            viewModel.IsSelectedSite = true

                            viewModel.isonsite = true
                            viewModel.isSelectedinline = false
                            type = "On-site"
                       
                        }) {
                            HStack {
                           
                                Text("On-site")
                                    .fontWeight(.semibold)
                                    .font(.caption)
                            }
                            .padding()
                            .foregroundColor(viewModel.IsSelectedSite ? .cyan:.gray)
                            .background(viewModel.IsSelectedSite ? .cyan.opacity(0.20):.gray.opacity(0.20))
                            .cornerRadius(90)
                            
                        }

                    }

            
                }
                .padding(.horizontal)
                if viewModel.isonsite {
                VStack(alignment:.leading){
                    Text("")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                    HStack {
                       
                        Button(action: {
                            viewlist1 = true
                }) {
                            HStack {
                                if isselectADD == false {
                               // if  viewModel.oldAddress == "Select Location" {
                                TextField("Select Address", text: $viewModel.oldAddress)  .accentColor(Color.cyan)
                                   
                                    .autocapitalization(.none).disabled(true)
                                    .padding(10)
                                    .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                .stroke(Address_pic.isEmpty ?
                                                        Color(UIColor(named: "Blue")!) :
                                                            Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                                    .foregroundColor(Address_pic.isEmpty ?
                                                     Color(UIColor(named: "Blue")!) :
                                                        Color(UIColor(named: "Blue")!))
                            
                           
                                        .animation(.default) } else {
                                            TextField("Select Address", text: $Address_pic)  .accentColor(Color.cyan)
                                               
                                                .autocapitalization(.none).disabled(true)
                                                .padding(10)
                                                .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                            .stroke(Address_pic.isEmpty ?
                                                                    Color(UIColor(named: "Blue")!) :
                                                                        Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                                                .foregroundColor(Address_pic.isEmpty ?
                                                                 Color(UIColor(named: "Blue")!) :
                                                                    Color(UIColor(named: "Blue")!))
                                        
                                       
                                                    .animation(.default)
                                        }
                             
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
                            if Isshow == true {
         if attendeneslist.count == 0 {
            ForEach(viewModel.emplyeelist, id: \.self) { emp in

                ForEach(viewModel.attendetry, id: \.self) { emp1 in
                    if emp1 == emp.id {
                        
                        //attendeneslist.append(emp)
                if emp.tokens == "null"{
                    Image(systemName: "person.crop.circle.fill").resizable() .foregroundColor(Color("LightGray")).frame(width: 50,height: 50)}
                else {
                    WebImage(url:URL(string: emp.tokens)).resizable().frame(width: 50,height: 50).clipShape(Circle())
                }
                }
                }
            }


            }
        }
                            
                    
                            if (attendeneslist.count > 4) {         ForEach(1...4, id: \.self) { row in

                                if attendeneslist[row].tokens == "null"{
                                        Image(systemName: "person.crop.circle.fill").resizable() .foregroundColor(Color("LightGray")).frame(width: 50,height: 50)}
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
                            if title == "" {
                            for em1 in viewModel.emplyeelist {
                                

                                for em in viewModel.MeetingObj.attendees{
                                    print("other imore")
                                    print(em.key)
                                    if em1.id == em.key{
                                        selectrow.insert(em1)
                                        attendeneslist.append(em1)
                                       
                                    }
                                }
                               title = "in"
                            }
                            }
                         //   Isshow = false
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
            HStack {
                Spacer()
            VStack(alignment: .trailing){
            Button {
                if !validate() {
                   presentAlert = true
                }
                else {
                    
                    Update()
                   dismiss()
                    }
                }
          

            
                label: {
                HStack{
                    Text("Save")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Blue"))
                    Circle().fill(
                        LinearGradient(gradient: Gradient(colors: [
                            Color(UIColor(named: "Blue")!),
                            Color(UIColor(named: "LightTeal")!)]),
                                       startPoint: .leading, endPoint: .trailing)).frame(width: 50, height: 50).overlay(Image(systemName: "chevron.right").foregroundColor(.white)    .font(.largeTitle)
)
                    
                }.padding(.trailing) .sheet(isPresented: $viewlist, content: {
                    AttendenceListViewselect(selectrow: $selectrow, selectatt: $Isselectattendense, isshow: $Isshow, attendeneslist: $attendeneslist)
                })
                }.padding(.trailing) .sheet(isPresented: $viewlist1, content: {
                 // LocationMeetingView()
                    locationselect(locations: $locations, location_add: $Address_pic, isselectADD: $isselectADD)
                })
            }.alert("Oops!..", isPresented: $presentAlert, actions: {
                // actions
            }, message: {
                Text(error0)
            })
            }
            .padding(.leading)
            .preferredColorScheme(.light)
        }.navigationBarTitle("Edit Meeting").toolbar {
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
            }.navigationBarTitleDisplayMode(.inline).task{
                viewModel.getMeetings(meetingid: meeting.id)
               
            }.toolbar {
                ToolbarItem(placement: .keyboard) {
                 
              
                    Button {
                        isfocus = false
                           } label: {
                           
                               HStack{
                                 
                                   Text("Done").foregroundColor(Color("Blue"))
                               

                           }

                           }
              
        }
            }
        
            }
        }
    func Update(){
        starttime0 = viewModel.MeetingObj.datetime_start.formatted(.dateTime.hour().minute())

        if attendeneslist.count > 0 {
        for attendeneslist in attendeneslist {
            
            attendenceID[attendeneslist.id] = "sent"

        }
        }
        else {
            for attendeneslist in viewModel.MeetingObj.attendees {
                
                attendenceID[attendeneslist.key] = "sent"

            }
        }

      //Date
        var calender = NSCalendar.current
        calender.timeZone = TimeZone(abbreviation: "GMT+3")!
        let datecomp = calender.dateComponents([.day,.month,.year], from: viewModel.MeetingObj.datetime_start)
        let timecomp = calender.dateComponents([.hour,.minute,.second], from: viewModel.MeetingObj.datetime_start)
        var newcomponent = DateComponents()
        newcomponent.timeZone = TimeZone(abbreviation: "GMT+3")
        
        newcomponent.day = datecomp.day
        newcomponent.month = datecomp.month
        newcomponent.year = datecomp.year
        newcomponent.hour = timecomp.hour
        newcomponent.minute = timecomp.minute
        newcomponent.second = timecomp.second
        let newintervaldate = calender.date(from: newcomponent)
        print(newintervaldate)
      
        let interval = Int( newintervaldate!.timeIntervalSince1970)
       print(interval)
        //End time
          var calender0 = NSCalendar.current
          calender0.timeZone = TimeZone(abbreviation: "GMT+3")!
          let datecomp0 = calender.dateComponents([.day,.month,.year], from: viewModel.MeetingObj.datetime_start)
        let endtime = calender.dateComponents([.hour,.minute,.second], from: viewModel.MeetingObj.datetime_end)
          var newcomponentEnd = DateComponents()
        newcomponentEnd.timeZone = TimeZone(abbreviation: "GMT+3")
          
        newcomponentEnd.day = datecomp0.day
        newcomponentEnd.month = datecomp0.month
        newcomponentEnd.year = datecomp0.year
        newcomponentEnd.hour = endtime.hour
        newcomponentEnd.minute = endtime.minute
        newcomponentEnd.second = endtime.second
          let intervalend = calender0.date(from: newcomponentEnd)
        
          let intervalEndtime = Int( intervalend!.timeIntervalSince1970)
         print(intervalEndtime)
        
      
        print(attendenceID)
        print(viewModel.MeetingObj.title)
        print(viewModel.MeetingObj.agenda)
        print(viewModel.MeetingObj.location)

        if  viewModel.isSelectedinline == true {
            type = "Online"
        }
        else {
            type = "On-site"
        }
        if  viewModel.isSelectedinline == false {
            if locations.count > 0 {
                
                viewModel.MeetingObj.latitude = "\(locations[0].coordinate.latitude)"
                viewModel.MeetingObj.longitude = "\(locations[0].coordinate.longitude)"
            }else {
                viewModel.MeetingObj.latitude = "0"
                viewModel.MeetingObj.longitude = "0"
            }
        }else {
            viewModel.MeetingObj.latitude = "0"
            viewModel.MeetingObj.longitude = "0"
        }
        print(type)
        print( viewModel.MeetingObj.latitude)
        print( viewModel.MeetingObj.longitude )

        self.ref.child("Meetings").child(meeting.id).updateChildValues(["title":viewModel.MeetingObj.title , "agenda":viewModel.MeetingObj.agenda ,"location":viewModel.MeetingObj.location,"type":type, "datetime_end":intervalEndtime ,"attendees":attendenceID,"latitude":viewModel.MeetingObj.latitude,"longitude":viewModel.MeetingObj.longitude , "datetime_start":interval])

   

    }
    

    func validate()-> Bool{
        
 
       var starttime0 = viewModel.MeetingObj.datetime_start.formatted(.dateTime.hour().minute())
       
                var hourin =  starttime0.prefix(2)
        
                      if hourin.suffix(1) == ":"
                      {
                          hourin = hourin.prefix(1)
        
                     }
        var minuted = viewModel.MeetingObj.datetime_start.formatted(.dateTime.minute())
        let AmOrPM = starttime0.suffix(2)
        //End time for validate
        let    endtime0 = viewModel.MeetingObj.datetime_end.formatted(.dateTime.hour().minute())
        
        
        var endhour =  endtime0.prefix(2)
         
                       if endhour.suffix(1) == ":"
                       {
                           endhour = endhour.prefix(1)
         
                      }
       
        let minutesend = viewModel.MeetingObj.datetime_end.formatted(.dateTime.minute())
        let AmOrPMend = endtime0.suffix(2)
     
        
        if AmOrPMend == "AM" && AmOrPM == "PM"
         {
            error0 = "Please enter a valid time"
            return false
        }
        if AmOrPMend == AmOrPM {
            if hourin == "12" && endhour == "12"{
                if minuted >= minutesend {
                    print("1")

                    error0 = "Please enter a valid time"
                    return false
                }
            }}
        
       if AmOrPMend == AmOrPM {

              if  endhour == "12"{
                if    (hourin != "12") {
                    print("3")

                    error0 = "Please enter a valid time"
                    return false
                }
                
            }
        }
        
        if AmOrPMend == AmOrPM   {
            if endhour != "12" &&  hourin != "12"{
                if endhour < hourin {
                    print("4")

            error0 = "Please enter a valid time"

            return false
            }
            }
            
        }
       

        if AmOrPMend == AmOrPM  && endhour == hourin {
            print("enter in 5")

          if  minutesend <= minuted{
              print("pig")
              error0 = "Please enter a valid time"

                return false
            }
        }
        
        if viewModel.MeetingObj.title == "" {
            error0 = "All fields are required"
            return false
        }
        
        if viewModel.MeetingObj.location == "" {
            error0 = "All fields are required"
            return false
        }
        
        if viewModel.MeetingObj.agenda == "" {
            error0 = "All fields are required"
            return false
        }
        
        if Isshow == false {
            if selectrow.count == 0 {
                error0 = "Please add at least one attendee"
                return false
            }
        }
            
        return true
    }
                                
    }
        
        
struct CustomTextEditor0: View {
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


struct EditMeetingView_Previews: PreviewProvider {
    
    static var previews: some View {
        EditMeetingView(meeting: Meeting(id: "1", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Cloud Security Engineers Meeting", datetime_start: .init(timeIntervalSince1970: TimeInterval(1646892000)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1646893800)),type: "On-site", location: "STC HQ, IT Meeting Room", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"attended", "SsemeSIGH6Syjkf8ctO8No1I3hB3":"attended"], agenda: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", latitude: "24.7534673", longitude: "46.6920362"))
    }
}
