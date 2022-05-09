//
//  LocationManagerExtension.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 06/05/2022.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseMessaging

extension LocationManager: CLLocationManagerDelegate{
    
    //MARK: - Private Struct
    // a work around to store variables of extensions that is not supported by Apple / Swift when
    // Location manager class isn't used
    private struct checkInHolder {
        static var checkedInAttribute = [String:Bool]()
    }
    
    private struct checkOutHolder {
        static var checkOutAttribute = [String:Bool]()
    }
    
    //MARK: - More of Getters And Setters for check-in attribute
    var CheckedIn:Bool {
        get {
            return checkInHolder.checkedInAttribute["is-checked-in"] ?? false
        }
        set(newValue) {
            checkInHolder.checkedInAttribute["is-checked-in"] = newValue
        }
    }
    
    //MARK: - More of Getters And Setters for check-out attribute
    var CheckedOut:Bool {
        get {
            return checkOutHolder.checkOutAttribute["is-checked-out"] ?? false
        }
        set(newValue) {
            checkOutHolder.checkOutAttribute["is-checked-out"] = newValue
        }
    }
    
    //MARK: - CLLocationManagerDelegate Functions
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("notDetermined")
            UserDefaults.standard.setValue(false, forKey: "location")
        case .restricted:
            print("restricted")
            UserDefaults.standard.setValue(false, forKey: "location")
        case .denied:
            print("denied")
            UserDefaults.standard.setValue(false, forKey: "location")
        case .authorizedAlways:
            print("authorizedAlways")
            UserDefaults.standard.setValue(true, forKey: "location")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            UserDefaults.standard.setValue(true, forKey: "location")
        @unknown default:
            print("default")
            UserDefaults.standard.setValue(false, forKey: "location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{
            print("Locations.last  is nil")
            return
        }
        self.userLocation = location
        print("Longitude: \(location.coordinate.longitude)")
        print("Latitude: \(location.coordinate.latitude)")
        
        //1- check for the user location if it inside
//        if (location.coordinate.l < Xmin || p.x > Xmax || p.y < Ymin || p.y > Ymax) {
//            // Definitely not within the polygon!
//        }
    }
}
