//
//  LocationRequestView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 06/05/2022.
//

import SwiftUI

struct LocationRequestView: View {
    var body: some View {
        ZStack{
            Color(.systemBlue)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 32)
                
                Text("Checkly Location Services is a MUST!")
                    .font(.system(size: 28, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text("start sharing your location with us, so we mark your attendance ")
                    .multilineTextAlignment(.center)
                    .frame(width: 340)
                    .padding()
                
                Spacer()
                
                VStack{
                    Button {
                        LocationManager.shared.requestLocation()
                    } label: {
                        Text("Allow Location")
                            .padding()
                            .font(.headline)
                            .foregroundColor(Color(.systemBlue))
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding()
                    
                    
                    Button {
                        print("dismiss button")
                    } label: {
                        Text("Maybe later")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.white)
                    }

                }
                .padding(.bottom, 32)
            }
            .foregroundColor(.white)
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
