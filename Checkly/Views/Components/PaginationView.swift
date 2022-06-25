//
//  PaginationView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 14/06/2022.
//
import SwiftUI

struct PaginationView: View {
    // MARK: - Constants
    let numberOfPages: Int
    let currentIndex: Int
    
    var body: some View {
        HStack(spacing: 8){
            ForEach(0..<numberOfPages){ index in
                if showIndex(index){
                    Circle().fill(currentIndex == index ? Color("coal") : Color("coal").opacity(0.5))
                        .scaleEffect(currentIndex == index ? 1 : 0.6)
                        .frame(width: 16, height: 16, alignment: .center)
                        .transition(AnyTransition.opacity.combined(with: .scale))
                        .id(index)
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 32, bottom: UIScreen.main.bounds.height*0.15, trailing: 0))
    }
    
    // MARK: - Function that returns if the index is in range
    func showIndex(_ index: Int) -> Bool {
        ((currentIndex - 1)...(currentIndex+1)).contains(index)
    }
}
