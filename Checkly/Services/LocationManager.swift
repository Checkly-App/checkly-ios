//
//  LocationManager.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 06/05/2022.
//

import Foundation
import firebase
import CoreLocation
import FirebaseMessaging

class LocationManager: NSObject, ObservableObject{
    
    
    //MARK: - private constants
    private let manager = CLLocationManager()
    
    //MARK: - private variables
    private var isCheckedIn = false
    private var isCheckedOut = false
    private var ref = Database.database().reference()
    private var storageRef = Storage.storage().reference()
    private let loggedInUserID = "PIfzRqUP9FdUf8cAr1UKHmxtEK12"
    private var companyAuth: String = ""
    
    
    private var geofence:[[[Double]]] = {
        [
            [
                46.616909354925156,
                24.76679670037757
            ],
            [
                46.61690130829811,
                24.766793047126765
            ],
            [
                46.616878509521484,
                24.766782087373688
            ],
            [
                46.616993844509125,
                24.76657019862392
            ],
            [
                46.61733716726303,
                24.7667004980703
            ],
            [
                46.617235243320465,
                24.766908733350338
            ],
            [
                46.61719769239426,
                24.766918475343196
            ],
            [
                46.616909354925156,
                24.76679670037757
            ]
        ]
    }
    
    private var minLongitude = 46.616878509521484
    private var maxLongitude = 46.61733716726303
    private var minLatitude = 24.76657019862392
    private var maxLatitude = 24.766918475343196
    
    
    
    
    //MARK: - @Published variables
    @Published var userLocation : CLLocation?
    
    //MARK: - Static variables
    static let shared = LocationManager()
    
    
    //MARK: - override init
    override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    //MARK: - Functions
    func requestLocation(){
        manager.requestAlwaysAuthorization()
    }
    
    private func sendPushNotification(attendanceType: String){
        //1- guard the creation of URL to firebase FCM send Template
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else{
            print("Error in cretaig the url of firebase FCM template")
            return
        }
        
        //2- get the first name from the employee full name
        let firstName = emp.name
        
        //3- create the title of notification based on the type parameter
        var title = ""
        if attendanceType == "check-in"{
            title = "Good Morning!"
        }else if attendanceType == "check-out"{
            title = "Take care!"
        }
        
        //4- create the body of notification based on the type parameter
        var body = ""
        if attendanceType == "check-in"{
            body = "We Checked You In \(firstName). At \(getDate()), \(getTime())"
        }else if attendanceType == "check-out"{
            body = "We Checked You Out \(firstName). At \(getDate()), \(getTime())"
        }
        
        //5- the serverKey linked in firebase and getted from apple developer account
        let serverKey = "AAAAUliWhLA:APA91bFG0wVWdJ7J6MIB03yV_J14KmO5VOZfXkvvzYe-ojxFWJOntALOi1Qhtihl3JAUA2r-ruQyLiOATT1ONThAh3HGCLbrpDzJwk2OuxtvgEFOnjzDLKz7CKjcRWc5fSMCyb-Me22r"
        //6- create the notification as json dictionary
        let json: [String:Any] = [
            "to": emp.token,
            "notification":[
                "title": title,
                "body": body
            ]
        ]
        //7- creating the http request
        var request = URLRequest(url: url)
        //8- determine the http method
        request.httpMethod = "POST"
        //9- setting the http body
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
        //10- setting the values of the request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        //11- creating the sessions
        let session = URLSession(configuration: .default)
        //12- setting the session request
        session.dataTask(with: request) { _, _, error in
            if let error = error {
                //13- if an error ocuured within the session
                print(error.localizedDescription)
                return
            }
            //14- success of notification
            print("success of notification")
        }
        .resume()
    }
}
