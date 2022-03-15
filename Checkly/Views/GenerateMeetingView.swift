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
import MapKit

struct GenerateMeetingView1: View {

    @State var sattendencelist0 =  Set<Employee>()

    var body: some View {
        ZStack{
            GenerateMeetingView()
        }
    }}

struct GenerateMeetingView: View {
    @StateObject var locationManager = LocationManager.shared

    @State  var locations: [Mark] = []

    @Environment(\.dismiss) var dismiss
    @State var title = ""
    @State var location = ""
    @State var starttime0 = ""
    @State var endtime0 = ""
    @State var street = "n"
    @State var city_c = ""
    @State var isshow = false
    @State var isshowadd = false

    @State var Address_pic = "Select Location"
    @FocusState private var isfocus : Bool

    @State var selectrow = Set<Employee>()
@State var attendeneslist: [Employee] = []
  //  @State var attendeeslist = [Employee]()
    @State var text = ""
    @State var type = "Online"
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

    @State  var starttime = Date()+86400
    @State  var endtime = Date()+86400
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
                          in: Date.now..., displayedComponents: [.hourAndMinute ]
                    ).labelsHidden().padding(.trailing).fixedSize().frame(maxWidth: .infinity/2,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.white.opacity(0.4)).environment(\.timeZone, TimeZone(abbreviation: "GMT+3")!)}
                    HStack{
                    Text("End time:")
                        .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "LightGray")!))
                        
                        DatePicker(
                              "End time",
                              selection: $endtime,
                              in: Date.now..., displayedComponents: [.hourAndMinute]
                        ).labelsHidden().fixedSize().frame(maxWidth: .infinity/2.5,maxHeight: 44, alignment: .leading).background(.gray.opacity(0.0)).cornerRadius(7).border(.white.opacity(0.4))
                    }
                }
              
               .padding(.horizontal)
                
                VStack(alignment:.leading){
                    Text("Agenda")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                    CustomTextEditor.init(placeholder: "enter meeting agenda", text: $text).focused($isfocus)
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
                    Text("")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor(named: "LightGray")!))
                    HStack {
                       
                        Button(action: {
                            viewlist1 = true
                }) {
                            HStack {
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
                                Image(systemName: "person.crop.circle.fill").resizable() .foregroundColor(Color("LightGray")).frame(width: 50,height: 50)}
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
            HStack {
                Spacer()
            VStack(alignment: .trailing){
            Button {
                if !validate(){
                   presentAlert = true
                }
                else {
                    Generate()
                    dismiss()
                }
          

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
                    AttendenceListViewselect(selectrow: $selectrow, selectatt: $Isselectattendense, isshow: $isshow, attendeneslist: $attendeneslist)
                })
                }.sheet(isPresented: $viewlist1, content: {
                 // LocationMeetingView()
                    locationselect(locations: $locations, location_add: $Address_pic, isselectADD: $isshowadd)
                })
            }.alert("Oops!..", isPresented: $presentAlert, actions: {
                // actions
            }, message: {
                Text(error0)
            })
            }
            .padding(.trailing)
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
        }
        }.navigationBarTitleDisplayMode(.inline).toolbar {
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
    
    func Generate(){
        var lang = "0"
        var long = "0"

        for attendeneslist in attendeneslist {
            
            attendenceID[attendeneslist.id] = "sent"

        }
        if IsSelectedSite {
            if locations.count > 0 {
                print(locations[0].coordinate.latitude)
                lang = "\(locations[0].coordinate.latitude)"
                long = "\(locations[0].coordinate.longitude)"
            }
        }

      //Date
        var calender = NSCalendar.current
        calender.timeZone = TimeZone(abbreviation: "GMT+3")!
        let datecomp = calender.dateComponents([.day,.month,.year], from: date)
        let timecomp = calender.dateComponents([.hour,.minute,.second], from: starttime)
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
          let datecomp0 = calender.dateComponents([.day,.month,.year], from: date)
          let endtime = calender.dateComponents([.hour,.minute,.second], from: endtime)
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
        

        ref.child("Meetings").childByAutoId().setValue(["title": title,"agenda": text,"host":userid,"location":location,"type":type,"datetime_start":interval,"datetime_end":intervalEndtime,"attendees":attendenceID,"latitude":lang,"longitude":long
                                                            ])

    }
    
    func validate()-> Bool{

        if starttime >= endtime {
            error0 = "Please enter a valid time"
                    return false
        }
 
        if title == ""{
            error0 = "All feilds are required"

            return false }
        if location == "" {
            error0 = "All feilds are required"

            return false }
        if text == "" {
            error0 = "All feilds are required"

            return false }
        if attendeneslist.count == 0{
            error0 = "Please add at least one attendee"

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
