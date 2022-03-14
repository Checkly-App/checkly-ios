//
//  LiquidSwipe.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 03/07/1443 AH.
//
import SwiftUI

struct LiquidSwipe: Shape {
    
    //MARK: - Variables
    var offset: CGSize
    var animatableData: CGSize.AnimatableData{
        get{ return offset.animatableData }
        set{ offset.animatableData = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
                        
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
 
            let from = 80 + offset.width
            path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
            var to = 180 - offset.width + offset.height
            to = to < 180 ? 180 : to

            let mid: CGFloat = 80 + ((to - 80) / 2)
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - 50, y: mid), control2: CGPoint(x: width - 50, y: mid))
  
        }
    }
}
