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
    
    //MARK: - Varibales
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    let names: [String] = ["k","l"]
    
    
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
                    
                    Image(uiImage: generateQRCode(string: "Noura Alsulayfih"))
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 200, height: 200, alignment: .center)
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 10, x: 1, y: 1)
                    
                    Text("Employee ID 1210116")
                        .foregroundColor(Color(.sRGB, red: 0.639, green: 0.631, blue: 0.631, opacity: 1))
                        .fontWeight(.medium)
                }
                Spacer()
                
                //3- check-ins items list
                CustomeShape()
                    .fill(
                        LinearGradient(colors: [Color(.sRGB, red: 0.255, green: 0.612, blue: 0.953, opacity: 1),
                                                Color(.sRGB, red: 0.345, green: 0.74, blue: 0.921, opacity: 1)]
                                       , startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: .infinity, height: 400, alignment: .center)
                    .overlay(
                        
                        VStack {
                            Text("Latest check-in")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            ScrollView {
                                
                            }
                        }
                    
                    )
                
                
                
                
                
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
}


struct CustomeShape: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY+5))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY+5), control1: CGPoint(x: rect.midX, y: -20), control2: CGPoint(x: rect.midX, y: -20))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct CardExpansion_Previews: PreviewProvider {
    static var previews: some View {
        CardExpansion()
    }
}
