//
//  ViewExtension.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/03/2022.
//
import UIKit
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
