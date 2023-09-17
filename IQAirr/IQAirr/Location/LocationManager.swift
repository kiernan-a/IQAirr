//
//  LocationManager.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/16/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            print("No locations available")
            return
        }
        let location = UserLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.latitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
