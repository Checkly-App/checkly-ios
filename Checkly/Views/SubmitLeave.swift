//
//  SubmitLeave.swift
//  Checkly
//
//  Created by Norua Alsalem on 24/03/2022.
//


import SwiftUI
import Firebase
import SwiftUILib_DocumentPicker
import FirebaseDatabase

struct submitLeave: View {
    
    @State var fromDate = Date()
    @State var toDate = Date()
    var types = ["Sick Leave", "Vacation"]
    @State private var selectedType = "Sick Leave"
    @State var showDocPicker = false
    @State private var notes: String = "Any additional notes?"
    var placeholderString: String = "Any additional notes?"
    @State private var showingAlert = false
    let emp_dep = "dep2"
    var manager_id = ""
    @ObservedObject var vm = submitLeaveViewModel()
    
    
    var body: some View {
        
        NavigationView {
        // Date Pickers
        VStack {
            
            
            DatePicker("From Date", selection: $fromDate, in: Date()... , displayedComponents: .date).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383)).padding().frame(width: 360, height: 45).background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.954, green: 0.954, blue: 0.954), Color(red: 0.954, green: 0.954, blue: 0.954).opacity(0)]), startPoint: .leading, endPoint: .trailing)).cornerRadius(7)
        
            DatePicker("To Date", selection: $toDate, in: Date()... , displayedComponents: .date).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383)).padding().frame(width: 360, height: 45).background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.954, green: 0.954, blue: 0.954), Color(red: 0.954, green: 0.954, blue: 0.954).opacity(0)]), startPoint: .leading, endPoint: .trailing)).cornerRadius(7)
            
            
        // leave type picker
            VStack {
                Picker(" ", selection: $selectedType) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }.padding()
            
            TextEditor(text: $notes).foregroundColor(self.notes == placeholderString ? .gray : .primary)
                .onTapGesture {
                  if self.notes == placeholderString {
                    self.notes = ""
                  }
                }
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
                
            
            Button("Select Supporting Document") {
              self.showDocPicker.toggle()
            }.foregroundColor(.gray)
                .padding()
                .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [10]))
            )
            .documentPicker(
              isPresented: $showDocPicker,
              documentTypes: ["public.folder"], onDocumentsPicked:  { urls in
                  print("Selected folder: \(urls.first!)")
              })
            
            Button("Submit") {
                vm.submitLeaveData(fromDate: fromDate, toDate: toDate, selectedType: selectedType, notes: notes, manager_id: manager_id)
                showingAlert = true
                self.notes = " "
                self.toDate = Date()
                self.fromDate = Date()
                self.selectedType = "Sick Leave"
            }.alert("Your request has been submitted", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            
        }
        }
    }
}


class submitLeaveViewModel: ObservableObject {
    
    var manager = ""
    
    init() {
        self.manager = fetchManager(emp_dep: "dep2")
    }
    
    

func fetchManager (emp_dep: String) -> String {
    
    let ref = Database.database().reference()
    let Queue = DispatchQueue.init(label: "searchQueue")
    var manager = ""
    
    Queue.sync {
                
        ref.child("Department/dep2").observe(.value, with: { dataSnapshot in

            let obj = dataSnapshot.value as! [String:Any]

            self.manager = obj["manager"] as! String
                    
            print("xxxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",self.manager)
            
            }, withCancel: { error in
                print(error.localizedDescription)
            })
    }
    
    print("xxxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",self.manager)
    
    return manager
   
}
    


    func submitLeaveData (fromDate: Date, toDate: Date, selectedType: String, notes: String, manager_id: String) {
    
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    
    let ref = Database.database().reference()

    let Leave: [String: Any] = [
        //auth
        "emp_id": "FJvmCdXGd7UWELDQIEJS3kisTa03",
        "start_date": formatter.string(from: fromDate),
        "end_date": formatter.string(from: toDate),
        "type": selectedType,
        "notes": notes,
        "status": "pending",
        "manager_id": self.manager,
        "employee_name": "Norah AlSalem"
    ]

    ref.child("Leave").childByAutoId().setValue(Leave)
}
    
}


    struct attendanceHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        submitLeave()
    }
}
    

