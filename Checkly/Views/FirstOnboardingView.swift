//
//  firstOnboardingView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 03/07/1443 AH.
//
import SwiftUI

struct FirstOnboardingView: View {
    
    //MARK: - @State
    @State var offset: CGSize = .zero
    @State var showNext = false
    @State var skip = false
    @State var second = false
    @State var third = false
    
    //MARK: - body
    var body: some View {
        ZStack{
            Color(.white)
                .overlay(
                    VStack(alignment: .leading){
                        Text("Checkly")
                            .bold()
                            .foregroundColor(.black)
                        Spacer()
                        Spacer()
                        Spacer()
                        VStack(alignment: .leading, spacing: 32){
                            VStack(alignment: .leading, spacing: 0){
                                Text("Smooth")
                                    .font(.system(size: 50))
                                    .fontWeight(.regular)
                                    .foregroundColor(Color(.sRGB, red: 0.184, green: 0.357, blue: 0.438, opacity: 1))
                                Text("Check-in !")
                                    .font(.system(size: 60))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.sRGB, red: 0.141, green: 0.196, blue: 0.304, opacity: 1))
                            }
                            Text("With Checkly you no longer have to wait in queues or pass by a machine to log your attendance")
                                .foregroundColor(Color(.sRGB, red: 0.184, green: 0.357, blue: 0.438, opacity: 1))
                                .font(.system(size: 20))
                        }
                        Spacer()
                        HStack{
                            HStack(alignment: .center, spacing: 16){
                                
                                Button {
                                    //nothing
                                } label: {
                                    Text("1")
                                        .font(.system(size: 40))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(.sRGB, red: 0.173, green: 0.694, blue: 0.937, opacity: 1))
                                    
                                }
                                
                                Button {
                                    second.toggle()
                                } label: {
                                    Text("2")
                                        .font(.system(size: 25))
                                        .fontWeight(.regular)
                                        .foregroundColor(Color(.sRGB, red: 0.817, green: 0.817, blue: 0.817, opacity: 1))
                                    
                                }
                                
                                Button {
                                    third.toggle()
                                } label: {
                                    Text("3")
                                        .font(.system(size: 25))
                                        .fontWeight(.regular)
                                        .foregroundColor(Color(.sRGB, red: 0.817, green: 0.817, blue: 0.817, opacity: 1))
                                    
                                }
                            }
                            Spacer()
                            Button {
                                //show home
                                skip.toggle()
                            } label: {
                                Text("Skip")
                                    .foregroundColor(Color(.sRGB, red: 0.184, green: 0.357, blue: 0.438, opacity: 1))
                                    .padding()
                            }
                            
                        }
                        .padding()
                    }
                        .padding(.init(top: 60, leading: 20, bottom: 20, trailing: 20))
                )
                .clipShape(LiquidSwipe(offset: offset))
                .overlay(
                    Image(systemName: "chevron.left")
                        .font(Font.title.weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                        .gesture(DragGesture().onChanged({ value in
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)){
                                offset = value.translation
                            }
                        }).onEnded({ value in
                            let screen = UIScreen.main.bounds
                            withAnimation(.spring()){
                                
                                if -offset.width > screen.width / 2{
                                    offset.width = -screen.height
                                    showNext.toggle()
                                }else{
                                    offset = .zero
                                }
                            }
                        }))
                        .onTapGesture {
                            showNext.toggle()
                        }
                        .offset(x: 15, y: 105)
                        .opacity(offset == .zero ? 1 : 0)
                    
                    ,alignment: .topTrailing
                )
                .padding(.trailing)
            if showNext {
                SecondOnboardingView()
            }
            if skip {
                LoginView()
            }
            if second {
                SecondOnboardingView()
            }
            if third {
                ThirdOnboardingView()
            }
        }
        .ignoresSafeArea()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(.sRGB, red: 0.341, green: 0.737, blue: 0.922, opacity: 1), Color(.sRGB, red: 0.263, green: 0.624, blue: 0.949, opacity: 1)]), startPoint: .top, endPoint: .bottom)
        )
    }
}

struct firstOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        FirstOnboardingView()
            .ignoresSafeArea()
            .preferredColorScheme(.light)
    }
}
