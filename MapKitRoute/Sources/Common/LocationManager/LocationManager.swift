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

@objc protocol LocationManagerDelegate: class {
    @objc optional func locationManager(_ manager: LocationManager, didSetAuthorization status: LocationAuthorization)
	
	@objc optional func userLocationUpdated(_ manager: LocationManager, locations: [CLLocation])
	@objc optional func userLocationUpdateFailed(_ manager: LocationManager, error: Error)
}

class LocationManager: NSObject {
    private var locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
	
	private var authorizationCallback: ((CLAuthorizationStatus) -> Void)?
	
	override init() {
		super.init()
		
		locationManager.delegate = self
	}
	
	func askUserPermissionIfNeeded(_ callback: @escaping (CLAuthorizationStatus) -> Void) -> Void {
        guard CLLocationManager.authorizationStatus() == .notDetermined else {
			callback(CLLocationManager.authorizationStatus())
			return
        }
		
		authorizationCallback = callback
        locationManager.requestAlwaysAuthorization()
    }
	
	func startTrackingUserLocation() -> Void {
		locationManager.startUpdatingLocation()
	}

	func stopTrackingUserLocation() -> Void {
		locationManager.stopUpdatingLocation()
	}
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		authorizationCallback?(status)
        delegate?.locationManager?(self, didSetAuthorization: status)
    }
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		delegate?.userLocationUpdated?(self, locations: locations)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		delegate?.userLocationUpdateFailed?(self, error: error)
	}
}
