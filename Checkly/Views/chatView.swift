//
//  chatView.swift
//  messages
//
//  Created by Noura Alsulayfih on 08/07/1443 AH.
//

import SwiftUI

struct chatView: View {
    
    let chatUser: Employee?
    let userID = "111111111"
    
    init(chatUser: Employee?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    @ObservedObject var vm: chatViewModel

    
    var body: some View {
        VStack{
            ScrollView{
                ScrollViewReader { ScrollViewProxy in
                    VStack{
                        ForEach(vm.chatMessages) { message in
                            VStack{
                                if message.fromID == userID {
                                    HStack{
                                        Spacer()
                                        HStack{
                                            Text(message.text)
                                                .foregroundColor(.white)
                                        }.padding()
                                            .background(Color(hexStringToUIColor(hex: "2CAFEE")))
                                            .cornerRadius(20, corners: [ .topLeft, .bottomRight, .bottomLeft])
                                            
                                    }
                                } else {
                                    HStack{
                                        HStack{
                                            Text(message.text)
                                                .foregroundColor(.black)
                                        }
                                        .padding()
                                        .background(Color.gray.opacity(0.5))
                                            .cornerRadius(20, corners: [ .topLeft, .topRight, .bottomRight])
                                        Spacer()
                                    }

                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 4)
                        }
                        HStack {
                            Spacer()
                        }
                        .id("empty")
                    }
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            ScrollViewProxy.scrollTo("empty", anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                HStack {
                    customTextField(placeholder: Text("Type something..."), text: $vm.chatText)
                    Button {
                        vm.handelSend()
                    } label: {
                        Image(systemName: "paperplane.circle.fill").font(.system(size: 45)).foregroundColor(Color(hexStringToUIColor(hex: "3DD2BB")))
                    }

                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top , 5)
                .background(Color(.systemBackground).ignoresSafeArea())
            }
        }
        .navigationTitle(chatUser?.name ?? "empty user")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct chatView_Previews: PreviewProvider {
    static var previews: some View {
            messagesView()
    }
}

struct customTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder.opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}


