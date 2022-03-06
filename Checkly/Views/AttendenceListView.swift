//
//  AttendenceListView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 21/07/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImageSwiftUI
import Foundation

struct AttendenceListView: View {
    @State var attendeeslist0 = [Employee]()
  
   

    @ObservedObject private var viewModel =
    EmployeeViewModel()
    var emp :Employee
    @Binding var attendeneslist: [Employee]

    @Binding var selectitem:Set<Employee>
    var isselect : Bool {
        selectitem.contains(emp)
       
    }
    var body: some View {
        HStack{
            if emp.tokens == "null"{
                Image(systemName: "person.circle.fill").resizable() .foregroundColor(Color("LightGray")).frame(width: 70,height: 70)}
            else{
                WebImage(url:URL(string: emp.tokens)).resizable().frame(width: 70,height: 70).clipShape(Circle())
            }
            VStack(alignment:.leading){
                Text(emp.name)
                    .font(.headline)
                    .foregroundColor(Color("DeepBlue"))
                Text(emp.position)
                    .font(.callout)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            
          
                Image(systemName: isselect ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isselect ? Color("Blue"):  .gray).imageScale(.large)
        
        }.onTapGesture {

            if isselect{
                selectitem.remove(emp)
                var i = 0
                for se in attendeneslist {
                    if se.id == emp.id{
                        attendeneslist.remove(at: i)
                    }
                   i = i+1
                }
               

               }
            else{
                selectitem.insert(emp)
                attendeneslist.append(emp)

            }
            //print("this contains")
            print(attendeneslist)
        }.padding()
    }}

struct AttendenceListViewselect: View {
    @ObservedObject private var viewModel = EmployeeViewModel()
  //  @StateObject var settings: GameSettings
   // @StateObject
    
    @Binding var selectrow : Set<Employee>
    @Binding var selectatt : Bool
    @Environment(\.dismiss) var dismiss
    @Binding var attendeneslist: [Employee]
    @State var attendeneslist1: [Employee] = []

    var body: some View {
        NavigationView{
        ZStack{
            VStack{
            List<Employee, ForEach<[Employee], String, AttendenceListView>>(viewModel.emplyeelist,selection: $selectrow){  empl in
                AttendenceListView(emp:empl,attendeneslist: $attendeneslist1, selectitem: $selectrow)
        }              .task {
            viewModel.fetchDatalist()
        }}
            VStack{
                Spacer()
            Button{
              
             //   attendeneslist1.removeAll()
                attendeneslist.removeAll()
                
                print("thiscontains'")
                for attend in attendeneslist1 {
                    attendeneslist.append(attend)
                }
                print(attendeneslist.count)
                print(attendeneslist1.count)
                selectatt = true
         dismiss()
        } label: {
            VStack{
            Text(" Save")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: 250)
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [
                        Color(UIColor(named: "Blue")!),
                        Color(UIColor(named: "LightTeal")!)]),
                                   startPoint: .leading, endPoint: .trailing))
                .cornerRadius(30.0)
        }

        }.background(.white.opacity(0.1))
            }
        }.background(.white).task{
            for attend in attendeneslist {
                attendeneslist1.append(attend)
            }
            
        }
        
        .navigationBarTitle(" Select Attendess")
}
    
        
    }}
struct AttendenceListView_Previews: PreviewProvider {
    static var previews: some View {
        AttendenceListViewselect( selectrow: (.constant(Set<Employee>())), selectatt: .constant(false), attendeneslist: .constant([]))
                                  
                                  }
}
