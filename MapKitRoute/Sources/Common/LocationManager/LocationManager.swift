//
//  LocationManager.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationAuthorization = CLAuthorizationStatus

protocol LocationManagerDelegate: class {
    func locationManager(_ manager: LocationManager, didSetAuthorization status: LocationAuthorization)
}

class LocationManager: NSObject {
    private var locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    func askUserPermissionIfNeeded() -> Void {
        guard CLLocationManager.authorizationStatus() == .notDetermined else {
            return
        }
        
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationManager(self, didSetAuthorization: status)
    }
}
