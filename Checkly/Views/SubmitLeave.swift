//
//  SubmitLeave.swift
//  Checkly
//
//  Created by Norua Alsalem on 24/03/2022.
//


import SwiftUI
import Firebase
import SwiftUILib_DocumentPicker

struct attendanceHistoryView: View {
    
    @State var fromDate = Date()
    @State var toDate = Date()
    var types = ["Sick Leave", "Vacation"]
    @State private var selectedType = "Vacation"
    @State var showDocPicker = false
    @State private var notes: String = ""
    
    var body: some View {
          
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
            
            TextEditor(text: $notes)
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
            
        }
    }
}


    struct attendanceHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        attendanceHistoryView()
    }
}
    
    struct CheckBox: View {

        @Binding var selectedStatus: String?
        var status: String

        var body: some View {
            Button(action: { self.selectedStatus = self.status }) {
                VStack{
                    Text(status).foregroundColor(.black)
                }.frame(width: 100, height: 100).background(Color(.green))
            }
    }
}

    // string extinsion to simplify substringing
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}
