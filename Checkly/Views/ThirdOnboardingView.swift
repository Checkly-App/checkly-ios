//
//  thirdOnboardingView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 03/07/1443 AH.
//
import SwiftUI

struct ThirdOnboardingView: View {
    
    //MARK: - @State
    @State var offset: CGSize = .zero
    @State var showNext = false
    @State var skip = false
    @State var back = false
    @State var first = false
    @State var second = false

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
                                Text("Bundle of")
                                    .font(.system(size: 50))
                                    .fontWeight(.regular)
                                    .foregroundColor(Color(.sRGB, red: 0.184, green: 0.357, blue: 0.438, opacity: 1))
                                Text("Services !")
                                    .font(.system(size: 60))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(.sRGB, red: 0.141, green: 0.196, blue: 0.304, opacity: 1))
                            }
                            Text("View your meetings, set your calendar, add your tasks, and do a lot more to organize your productive day with Checkly")
                                .foregroundColor(Color(.sRGB, red: 0.184, green: 0.357, blue: 0.438, opacity: 1))
                                .font(.system(size: 20))
                        }
                        Spacer()
                        HStack(alignment: .center){
                            Button {
                                //show second
                                back.toggle()
                            } label: {
                                Text("back")
                                    .foregroundColor(Color(.sRGB, red: 0.184, green: 0.357, blue: 0.438, opacity: 1))
                                    .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 8))
                            }
                            Spacer()
                            HStack(alignment: .center, spacing: 16){
                                
                                Button {
                                    first.toggle()
                                } label: {
                                    Text("1")
                                        .font(.system(size: 25))
                                        .fontWeight(.regular)
                                        .foregroundColor(Color(.sRGB, red: 0.817, green: 0.817, blue: 0.817, opacity: 1))
                                }
                                
                                Button {
                                    second.toggle()
                                } label: {
                                    Text("2")
                                        .font(.system(size: 25))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(.sRGB, red: 0.817, green: 0.817, blue: 0.817, opacity: 1))
                                }
                                
                                Button {
                                    //nothing
                                } label: {
                                    Text("3")
                                        .font(.system(size: 40))
                                        .fontWeight(.regular)
                                        .foregroundColor(Color(.sRGB, red: 0.173, green: 0.694, blue: 0.937, opacity: 1))
                                }
                            }
                            .padding()
                        }
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
                LoginView()
            }
            if skip {
                LoginView()
            }
            if back {
                SecondOnboardingView()
            }
            if first {
                FirstOnboardingView()
            }
            if second {
                SecondOnboardingView()
            }
            
        }
        .ignoresSafeArea()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(.sRGB, red: 0.341, green: 0.737, blue: 0.922, opacity: 1), Color(.sRGB, red: 0.263, green: 0.624, blue: 0.949, opacity: 1)]), startPoint: .top, endPoint: .bottom)
        )
    }
}

struct thirdOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdOnboardingView()
            .ignoresSafeArea()
    }
}
