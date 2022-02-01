//
//  ViewExtension.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//

import SwiftUI

extension View {
    func BlueTextField() -> some View {
        self
            .overlay(Rectangle()
                        .frame(height: 2)
                        .padding(.top, 35.0))
            .foregroundColor(Color(UIColor(named: "Blue")!))
            .padding(10)
    }
    
    func GrayTextFeild() -> some View {
        self
            .padding(.vertical, 10.0)
            .overlay(Rectangle()
                        .frame(height: 2)
                        .padding(.top, 35.0))
            .foregroundColor(Color(UIColor(named: "Gray")!))
            .padding(10)
    }
}

