//
//  LocationMeetingView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 24/07/1443 AH.
//

import SwiftUI
import MapKit
struct LocationMeetingView: View {
    var body: some View {
        locationview()
    }
}

struct LocationMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMeetingView().ignoresSafeArea(.all)
    }
}

struct locationview :UIViewRepresentable {
    @State var lan = 24.7595381
    @State var lon = 46.7248848

    @StateObject var locationManager = LocationManager()
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0.0)"
       }
       
       var userLongitude: String {
           return "\(locationManager.lastLocation?.coordinate.longitude ?? 0.0)"
       }
    func makeCoordinator() -> locationview.cordinetor {
        return locationview.cordinetor(parent1: self)
    }
    func makeUIView(context: UIViewRepresentableContext<locationview>) ->  MKMapView {
        let map = MKMapView()
        let cordinate = CLLocationCoordinate2D(latitude: lan, longitude: lon)
        map.region = MKCoordinateRegion(center: cordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let annomatipon = MKPointAnnotation()
        annomatipon.coordinate = cordinate
        map.delegate = context.coordinator
       // map.delegate = context.coordinator
        map.addAnnotation(annomatipon)
        return map
    }
    

func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<locationview>) {
    


}
    class cordinetor :NSObject,MKMapViewDelegate{
        
        var perent: locationview
        
        init (parent1:locationview){
            perent = parent1
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
         pin.isDraggable = true
          pin.tintColor = .red
            
//         //   pin.dragState =
        // pin.pinTintColor = .red
//           pin.animatesDrop = true
          //  pin.setDragState(pin.dragState, animated: true)
            return pin
        }
    }
}


