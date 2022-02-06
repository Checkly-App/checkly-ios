//
//  ContentView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//

import SwiftUI
import FirebaseAuth



struct mainview: View {
    @Binding var showMenu: Bool

    var body: some View {
    Button(action: {
       // self.isOpen.toggle()
        withAnimation {
            
                      self.showMenu = true
                   }

    }) {
        HStack {
            Image(systemName: "filemenu.and.selection")
                  .foregroundStyle(.teal, .gray)
                  .font(.system(size: 42.0))
        }
    }.position(x: 100, y: 100)
        
        
        
        ////Noura code Home 
            Text("welcome")
    
    }}
    
struct ContentView: View {
    @State var showMenu = false
  
    var body: some View {
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width < -100 {
                            withAnimation {
                                showMenu = false                        }
                        }
                    }
        let closetap = TapGesture().onEnded{
            
          
                withAnimation {
                    showMenu = false                        }
            }
        
      
                    

        
       return GeometryReader{ gemotry in
            ZStack(alignment: .leading) {
                mainview(showMenu: self.$showMenu).frame(width: gemotry.size.width, height: gemotry.size.height).offset(x: self.showMenu ? gemotry.size.width/2 : 0)
                    .disabled(self.showMenu ? true : false)
            }.gesture(closetap).gesture(drag)
            if self.showMenu {
                MenuView()
                    .frame(width: gemotry.size.width/1.9)    .transition(.move(edge: .leading))

                }
            
        }
        
     
    }
}

//struct ContentView: View {
//    @State var isOpen = false
//    var body: some View {
//
//
//        ZStack{
//            if !isOpen {
//        Button(action: {
//            self.isOpen.toggle()
//        }) {
//            HStack {
//                Image(systemName: "filemenu.and.selection")
//                      .foregroundStyle(.teal, .gray)
//                      .font(.system(size: 42.0))
//            }
//        }.position(x: 100, y: 100)
//                Text("welcome")
//        }
//            sidemenu(width: UIScreen.main.bounds.width/2.5, menuopen: isOpen, togglemenu: toglemenu)
//        }.edgesIgnoringSafeArea(.all)
//
//    }
//    func toglemenu() {
//        isOpen.toggle()
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
