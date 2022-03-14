//
//  secondOnboardingView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 03/07/1443 AH.
//
import SwiftUI

struct SecondOnboardingView: View {
    
    //MARK: - @State
    @State var offset: CGSize = .zero
    @State var showNext = false
    @State var skip = false
    @State var back = false
    @State var first = false
    @State var third = false

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(.sRGB, red: 0.341, green: 0.737, blue: 0.922, opacity: 1), Color(.sRGB, red: 0.263, green: 0.624, blue: 0.949, opacity: 1)]), startPoint: .top, endPoint: .bottom)
                .overlay(
                    VStack(alignment: .leading){
                        Text("Checkly")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                        Spacer()
                        Spacer()
                    VStack(alignment: .leading, spacing: 32){
                        VStack(alignment: .leading, spacing: 0){
                            Text("Automated")
                                .font(.system(size: 50))
                                .fontWeight(.regular)
                                .foregroundColor(Color(.sRGB, red: 0.746, green: 0.915, blue: 1, opacity: 1))
                            Text("Process !")
                                .font(.system(size: 60))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1))
                        }
                        Text("Forget the outdated manual approches for recording your attendance. Checkly takes care of it for you")
                            .foregroundColor(Color(.sRGB, red: 0.746, green: 0.915, blue: 1, opacity: 1))
                            .font(.system(size: 20))
                    }
                        Spacer()
                        HStack(alignment: .center, spacing: 50){
                            Button {
                                //show first
                                back.toggle()
                            } label: {
                                Text("back")
                                    .foregroundColor(Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1))
                                    .multilineTextAlignment(.leading)

                            }
                            HStack(alignment: .center, spacing: 16){
                                
                                
                                Button {
                                    first.toggle()
                                } label: {
                                    Text("1")
                                        .font(.system(size: 25))
                                        .fontWeight(.regular)
                                        .foregroundColor(Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1))
                                }
                                
                                Button {
                                    // nothing
                                } label: {
                                    Text("2")
                                        .font(.system(size: 40))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }

                                Button {
                                    third.toggle()
                                } label: {
                                    Text("3")
                                        .font(.system(size: 25))
                                        .fontWeight(.regular)
                                        .foregroundColor(Color(.sRGB, red: 0.88, green: 0.963, blue: 1, opacity: 0.6))
                                }
                            }
                            .frame(maxWidth: .infinity)

                            Button {
                                //show home
                                skip.toggle()
                            } label: {
                                Text("skip")
                                    .foregroundColor(Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1))
                            }

                        }
                        .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .frame(maxWidth: .infinity)

                    }
                        .padding(.init(top: 60, leading: 20, bottom: 20, trailing: 20))
                )
                .clipShape(LiquidSwipe(offset: offset))
                .overlay(
                    Image(systemName: "chevron.left")
                        .font(Font.title.weight(.bold))
                        .foregroundColor(Color(.sRGB, red: 0.173, green: 0.694, blue: 0.937, opacity: 1))
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
                ThirdOnboardingView()
            }
            if skip {
                LoginView()
            }
            if back {
                FirstOnboardingView()
            }
            if first {
                FirstOnboardingView()
            }
            if third {
                ThirdOnboardingView()
            }        }
        .ignoresSafeArea()
        .background(Color.white)
    }
}

struct secondOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        SecondOnboardingView()
            .ignoresSafeArea()
    }
}
