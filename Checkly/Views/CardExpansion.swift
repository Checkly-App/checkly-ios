//
//  CardExpansion.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 27/07/1443 AH.
//

import SwiftUI
import CoreImage.CIFilterBuiltins



struct CardExpansion: View {
    
    //MARK: - @Environement Objects
    @Environment(\.presentationMode) var presentationMode
    
    @State var timeDate = "hh:mm:ss"
    @State var date = "eeee dd mm yyyy"
        
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeDate = getTime()
        }
    }
    
    var updateDate: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.date = getDate()
        }
    }
    
    //MARK: - Varibales
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    let names: [String] = ["k","l"]
    var emp: Employee
    
    
    //MARK: - Body
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
                Spacer()
                
                //1- Sheet's title
                Text("Your Digital Card")
                    .foregroundColor(Color(.sRGB, red: 0.383, green: 0.383, blue: 0.383, opacity: 1))
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                Spacer()
                
                //2- QR Code and employee id
                VStack(alignment: .center, spacing: 16){
                    //encode the string
                    Image(uiImage: generateQRCode(string: "\(emp.id)-\(emp.name)-\(date)-\(timeDate)"))
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 200, height: 200, alignment: .center)
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 10, x: 1, y: 1)
                    
                    Text("Employee ID \(emp.id)")
                        .foregroundColor(Color(.sRGB, red: 0.639, green: 0.631, blue: 0.631, opacity: 1))
                        .fontWeight(.medium)
                }
                .onAppear {
                    let _ = self.updateTimer
                    let _ = self.updateDate
                }
                Spacer()
                
                //3- check-ins items list
                CustomeShape()
                    .fill(
                        LinearGradient(colors: [Color(.sRGB, red: 0.255, green: 0.612, blue: 0.953, opacity: 1),
                                                Color(.sRGB, red: 0.345, green: 0.74, blue: 0.921, opacity: 1)]
                                       , startPoint: .top, endPoint: .bottom)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 400, alignment: .center)

                
                
                
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                            .fontWeight(.medium)
                            .foregroundColor(Color(.sRGB, red: 0.024, green: 0.661, blue: 0.958, opacity: 1))
                        
                    }
                }
            }
            .ignoresSafeArea()
            .background(
                LinearGradient(colors: [Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1),Color(.sRGB, red: 0.954, green: 0.954, blue: 0.954, opacity: 1)], startPoint: .top, endPoint: .bottom)
            )
        }
    }
    
    //MARK: - Functions
    func generateQRCode(string: String) -> UIImage{
        filter.message = Data(string.utf8)
        if let outpuImage = filter.outputImage {
            if let cgImage = context.createCGImage(outpuImage, from: outpuImage.extent){
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func getTime()->String{
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    
    func getDate()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d yyyy")
        return dateFormatter.string(from: Date())
    }
}


struct CustomeShape: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY+20))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY+10), control1: CGPoint(x: rect.midX, y: rect.minY-20), control2: CGPoint(x: rect.midX, y: rect.minY-20))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct CardExpansion_Previews: PreviewProvider {
    
    static let employee = Employee(address: "", birthdate: "", department: "", email: "", id: "", gender: "", name: "", national_id: "", phone_number:  "", position: "", photoURL: "")
    
    static var previews: some View {
        CardExpansion(emp: employee)
    }
}
