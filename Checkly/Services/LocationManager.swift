
import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {

    private let locationManager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    static let shared = LocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func requestlocation(){
        locationManager.requestWhenInUseAuthorization()
    }

}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")

        case .denied:
            print("denied")

        case .authorizedAlways:
            print("authorizedAlways")

        case .authorizedWhenInUse:
            print("authorizedWhenInUse")

        case .authorized:
            print("authorized")

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location  = locations.last else  {return}
        self.lastLocation = location
    }
}
