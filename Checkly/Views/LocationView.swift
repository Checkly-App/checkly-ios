import MapKit
import SwiftUI
struct locationselect: View {
    @Binding var locations: [Mark]
    @Binding  var location_add : String
   

//
    @Environment(\.dismiss) var dismiss

    @State private var region =  MKCoordinateRegion(center: CLLocationCoordinate2D(
        latitude: 24.7595381, longitude: 46.7248848 ),
        latitudinalMeters: 1000, longitudinalMeters: 1000 )
    
    
    //= MKCoordinateRegion(
//        center: CLLocationCoordinate2D(
//            latitude: 24.7595381,
//            longitude: 46.7248848
//        ) , latitudinalMeters: 10000, longitudinalMeters: 10000,
//        span: MKCoordinateSpan(
//            latitudeDelta: 10,
//            longitudeDelta: 10
//        )
//    )
    @StateObject var locationManager = LocationManager()
       
       var userLatitude: String {
           return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
       }
       
       var userLongitude: String {
           return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
       }
    private func setRegio(){
    //    locationManager.requestLocation()

        if locations .count > 0 {
           region = MKCoordinateRegion(center: CLLocationCoordinate2D(
            latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude),
                                       latitudinalMeters: 1000, longitudinalMeters: 1000)}
        else {
           
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(
                latitude: Double(userLatitude)!, longitude: Double(userLongitude)! ),
                                        latitudinalMeters: 1000, longitudinalMeters: 1000)
            
        }
    }
       
    var body: some View {
        NavigationView{
        ZStack {
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                MapAnnotation(
                    coordinate: location.coordinate,
                    anchorPoint: CGPoint(x: 0.5, y: 0.7)
                ) {
                    VStack{
                        if location.show {
                            Text("Test")
                        }
                        Image(systemName: "")
                            .font(.title)
                            .foregroundColor(.cyan)
                            .onTapGesture {
                                let index: Int = locations.firstIndex(where: {$0.id == location.id})!
                                locations[index].show.toggle()
                            }
                    }
                }
            }
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.cyan)
                .opacity(1)
                
            VStack {
                Spacer()
                HStack {
                   
                    Button(action: {
                    

                        if locations.count > 0 {
                            locations.removeAll()
                        }
                        locations.append(Mark(coordinate: region.center))
                        print(locations)
                        getAddress()
                        dismiss()
                    }){
                        VStack{
                        Text("Select")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: 250)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [
                                    Color(UIColor(named: "Blue")!),
                                    Color(UIColor(named: "LightTeal")!)]),
                                               startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(30.0)
                        }.padding().padding()

                    }
                }.onAppear(perform: {
                  
                    setRegio()
                })
            }
        }
        .ignoresSafeArea()
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                           dismiss()
                       } label: {
                           HStack{
                Image(systemName: "chevron.left")
                               Text("Back").foregroundColor(Color("Blue"))
                           }

                       }
            }
        }
    }
    func getAddress(){
            var address: String = ""

            let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            //selectedLat and selectedLon are double values set by the app in a previous process

            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]

                // Address dictionary
                //print(placeMark.addressDictionary ?? "")

                // Location name
                if let locationName = placeMark.addressDictionary!["Name"] as? String {
                    print(locationName)
                    location_add =   locationName as String
                }

                // Street address
                if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                    print(street)
                    
                }

                // City
                if let city = placeMark.addressDictionary!["City"] as? String {
                    print(city)
                    location_add = location_add + city as String
                }

                // Zip code
                if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                    print(zip)
                }

                // Country
                if let country = placeMark.addressDictionary!["Country"] as? String {
                    print(country)
                    location_add = location_add + country as String
                }

            })

          
        }
}
struct locationselect_Previews: PreviewProvider {
    static var previews: some View {
        locationselect(locations: .constant([Mark]()), location_add: .constant("") )
    }
}
struct Mark: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var show = false
}
