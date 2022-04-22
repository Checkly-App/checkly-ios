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
import FirebaseAuth
import FirebaseStorage

struct submitLeave: View {
    
    @State var fromDate = Date()
    @State var toDate = Date()
    var types = ["Sick Leave", "Vacation"]
    @State private var selectedType = "Sick Leave"
    @State var showDocPicker = false
    @State private var notes: String = "Any additional notes?"
    var placeholderString: String = "Any additional notes?"
    @State private var showingAlert = false
    @State private var showingError = false
    let emp_dep = "dep2"
    var manager_id = ""
    @ObservedObject var vm = submitLeaveViewModel()
    @State private var didTapSickLeave:Bool = true
    @State private var didTapVacation:Bool = false
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    
    
    var body: some View {
        
       
        // Date Pickers
        VStack {

            
            DatePicker("From Date", selection: $fromDate, in: Date()... , displayedComponents: .date).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383)).padding().frame(width: 360, height: 45).background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.954, green: 0.954, blue: 0.954), Color(red: 0.954, green: 0.954, blue: 0.954).opacity(0)]), startPoint: .leading, endPoint: .trailing)).cornerRadius(7)
        
            DatePicker("To Date", selection: $toDate, in: Date()... , displayedComponents: .date).foregroundColor(Color(red: 0.383, green: 0.383, blue: 0.383)).padding().frame(width: 360, height: 45).background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.954, green: 0.954, blue: 0.954), Color(red: 0.954, green: 0.954, blue: 0.954).opacity(0)]), startPoint: .leading, endPoint: .trailing)).cornerRadius(7)
            
            
            HStack (alignment: .center){
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(didTapSickLeave ? Color(red: 0.173, green: 0.694, blue: 0.937) : Color.gray ).opacity(0.2)
                .frame(width: 120, height: 35).overlay(Text("Sick Leave").foregroundColor(didTapSickLeave ? Color(red: 0.173, green: 0.694, blue: 0.937) : Color.gray)).onTapGesture {
                    self.didTapSickLeave = true
                    self.didTapVacation = false
                    self.selectedType = "Sick Leave"
                }
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(didTapVacation ? Color(red: 0.173, green: 0.694, blue: 0.937) : Color.gray ).opacity(0.2)
                .frame(width: 120, height: 35).overlay(Text("Vacation").foregroundColor(didTapVacation ? Color(red: 0.173, green: 0.694, blue: 0.937) : Color.gray)).onTapGesture {
                        self.didTapSickLeave = false
                        self.didTapVacation = true
                    self.selectedType = "Vacation"
                    }
            }.padding()
        
            TextEditor(text: $notes).foregroundColor(self.notes == placeholderString ? .gray : .primary)
                .onTapGesture {
                  if self.notes == placeholderString {
                    self.notes = ""
                  }
                }
                .frame(width: 300, height: 100)
                .foregroundColor(.black)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
                
            Button("Select Supporting Document") {
                shouldShowImagePicker.toggle()
            }.foregroundColor(.gray)
                .padding()
                .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [10]))
            )
            if let image = self.image {
                Text("Document Selected!").font(.caption).foregroundColor(.gray)
            }
            Spacer()
            HStack{
                Spacer()
                Text("Submit").font(.system(size: 16, weight: .bold))
                Spacer()
                }.foregroundColor(.white)
                .padding(.vertical)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.345, green: 0.737, blue: 0.925), Color(red: 0.263, green: 0.624, blue: 0.953)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
                .contentShape(Rectangle())
                .onTapGesture {
                    if let image = self.image {
                        vm.persistImageToStorage(image: image, leave_id: "000", fromDate: fromDate, toDate: toDate, selectedType: selectedType, notes: notes, manager_id: manager_id)

                    showingAlert = true
                    self.notes = " "
                    self.toDate = Date()
                    self.fromDate = Date()
                    self.selectedType = "Sick Leave"
                    self.didTapSickLeave = true
                    self.image = nil
                    } else {
                        showingError = true
                    }
                    
                }.alert("Your request has been submitted", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                .alert("Please select a supporting document", isPresented: $showingError) {
                    Button("OK", role: .cancel) { }
                }
                
        
            
        }.padding().navigationTitle("Submit Leave Request").navigationBarTitleDisplayMode(.inline).fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
        
    }
}


class submitLeaveViewModel: ObservableObject {
    
    var manager = ""
    var dep = ""
    var name = ""
    let user = Auth.auth().currentUser
    
    init() {
        getDepartment()
    }
    
    func getDepartment() {
    
  
    let ref = Database.database().reference()
    let Queue = DispatchQueue.init(label: "Queue")
    
        Queue.sync {
            
            ref.child("Employee/\(user!.uid)").observe(.value, with: { dataSnapshot in

                let obj = dataSnapshot.value as! [String:Any]
                let department = obj["department"] as! String
                let name = obj["name"] as! String
              
                self.name = name
                self.dep = department
                self.manager = self.fetchManager(emp_dep: self.dep)
                    
            }, withCancel: { error in
                print(error.localizedDescription)
            })
            
    }
}
    

func fetchManager (emp_dep: String) -> String {
    
    let ref = Database.database().reference()
    let Queue = DispatchQueue.init(label: "searchQueue")
    let manager = ""
    
    Queue.sync {
                
        ref.child("Department/\(emp_dep)").observe(.value, with: { dataSnapshot in

            let obj = dataSnapshot.value as! [String:Any]

            self.manager = obj["manager"] as! String
                    
            }, withCancel: { error in
                print(error.localizedDescription)
            })
    }
    
    return manager
   
}
    
    func persistImageToStorage(image: UIImage, leave_id: String, fromDate: Date, toDate: Date, selectedType: String, notes: String, manager_id: String){
        
        var Message:String = " "
        
        let ref = Storage.storage().reference().child("Leaves/\(leave_id)")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    Message = "Failed to push image to Storage: \(err)"
                    return
                }

                ref.downloadURL { url, err in
                    if let err = err {
                        Message = "Failed to retrieve downloadURL: \(err)"
                        return
                    }

                    Message = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                    print("XXXXXXXXXXXXXXXXxxxxxxxxxxxx")
                    print(url!.absoluteString)
                    var photoURL = url!.absoluteString
                    self.submitLeaveData(fromDate: fromDate, toDate: toDate, selectedType: selectedType, notes: notes, manager_id: manager_id, phptoURL: photoURL)
                    print("xxxxxxxxxxxxxxxxxxxxxxxxx")
                }
            }
       
        }
    


    func submitLeaveData (fromDate: Date, toDate: Date, selectedType: String, notes: String, manager_id: String, phptoURL:String) {
    
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    
    let ref = Database.database().reference()
    let leave_id =  UUID().uuidString
    let Leave: [String: Any] = [
        
        "emp_id": user!.uid,
        "start_date": formatter.string(from: fromDate),
        "end_date": formatter.string(from: toDate),
        "type": selectedType,
        "notes": notes,
        "status": "pending",
        "manager_id": self.manager,
        "employee_name":  self.name,
        "leave_id": leave_id,
        "image_token": phptoURL
    ]

    ref.child("Leave").childByAutoId().setValue(Leave)
        
        //persistImageToStorage(image: image, leave_id: leave_id)
}
    
}


    struct attendanceHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        submitLeave()
    }
}
    

