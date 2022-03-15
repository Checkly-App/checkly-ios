

//
//  chatView.swift
//  messages
//
//  Created by Noura Alsulayfih on 08/07/1443 AH.
//
import SwiftUI

struct chatView: View {
    
    let chatUser: Employee?
    let userID = "FJvmCdXGd7UWELDQIEJS3kisTa03"
    
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
                                            .background(Color(red: 0.341, green: 0.733, blue: 0.925))
                                            .cornerRadius(20, corners: [ .topLeft, .bottomRight, .bottomLeft])
                                            
                                    }
                                } else {
                                    HStack{
                                        HStack{
                                            Text(message.text)
                                                .foregroundColor(.black)
                                        }
                                        .padding()
                                        .background(Color(red: 0.769, green: 0.769, blue: 0.769)).opacity(0.8)
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
                        Image(systemName: "paperplane.circle.fill").font(.system(size: 45)).foregroundColor(Color(red: 0.239, green: 0.824, blue: 0.733))
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
