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
        
       return GeometryReader{ gemotry in
            ZStack(alignment: .leading) {
                mainview(showMenu: self.$showMenu).frame(width: gemotry.size.width, height: gemotry.size.height).offset(x: self.showMenu ? gemotry.size.width/2 : 0)
                    .disabled(self.showMenu ? true : false)
            }.gesture(drag)
            if self.showMenu {
                MenuView()
                    .frame(width: gemotry.size.width/2)    .transition(.move(edge: .leading))

                }
            
        }
        
     
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
