//
//  CreateRoadViewController.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit
import MapKit

class CreateRoadViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonContainer: UIVisualEffectView!
    
    @IBOutlet weak var mapView: MKMapView!
    private var locationManager: LocationManager!
    
    private var isTracking: Bool = false
    private var recordedSteps: [Coordinate]?
	private var calculatedStepsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager = LocationManager()
		locationManager.delegate = self
        
        stopButton.isHidden = true
        saveButtonContainer.isHidden = true
		
		mapView.showsUserLocation = true
		mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startTracking() {
        UIView.animate(withDuration: 0.25) {
            self.startButton.isHidden = true
            self.stopButton.isHidden = false
            self.saveButtonContainer.isHidden = true
        }
        
		locationManager.askUserPermissionIfNeeded() { [weak self] (status: CLAuthorizationStatus) in
			guard status == .denied else {
				return
			}
			
			self?.mapView.setUserTrackingMode(.followWithHeading, animated: true)
			self?.isTracking = true
		}
    }
    
    @IBAction func stopTracking() {
        UIView.animate(withDuration: 0.25) {
            self.startButton.isHidden = true
            self.stopButton.isHidden = true
            self.saveButtonContainer.isHidden = false
        }
        
        isTracking = false
        mapView.setUserTrackingMode(.follow, animated: true)
		
		calculatePaths()
    }
    
    @IBAction func saveRoad() {
		guard let recordedSteps = self.recordedSteps,
			recordedSteps.count > 0 else {
			showAlert(title: "No steps recorded", message: "Sorry bro... learn to code ! ;)")
			return
		}
		
		let alert = UIAlertController(title: "Name your road", message: "PLZ!!!!", preferredStyle: .alert)
		
		alert.addTextField { (textField) in
			textField.placeholder = "Name"
		}
		
		let action = UIAlertAction(title: "Save !", style: .default) { _ in
			guard let name = alert.textFields?.first?.text else {
				return
			}
			
			alert.dismiss(animated: true, completion: nil)
			
			self.saveRoad(named: name)
			self.dismiss()
		}
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
    }
    
	private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
			
			completion?()
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
	
	private func showNoRouteRecorded() {
		showAlert(title: "No route recorded", message: "That's it. LOL")
	}
	
	private func saveRoad(named name: String) -> Void {
		guard let steps = recordedSteps else {
			return
		}
		
		let roadsService = SavedRoadsService()
		
		let road = Road(steps: steps, name: name)
		roadsService.addRoad(road)
	}
}

extension CreateRoadViewController: LocationManagerDelegate {
	func userLocationUpdated(_ manager: LocationManager, locations: [CLLocation]) {
		let newSteps = locations.map { (location) -> Coordinate in
			return location.coordinate
		}
		
		recordedSteps = (recordedSteps ?? []) + newSteps
	}
	
	func userLocationUpdateFailed(_ manager: LocationManager, error: Error) {
		print(error)
	}
}

extension CreateRoadViewController: MKMapViewDelegate {
	
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        recordedSteps = []
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        showAlert(title: "MAPVIEW", message: "Stoped locating user")
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        showAlert(title: "MAPVIEW", message: "Failed locating user : \(error.localizedDescription)")
    }
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay: overlay)
		renderer.strokeColor = UIColor.red
		renderer.lineWidth = 4.0
		
		return renderer
	}
}

extension CreateRoadViewController {
	func calculatePaths() -> Void {
		guard let steps = recordedSteps else {
			showNoRouteRecorded()
			return
		}
		calculatedStepsCount = 0
		
		for index in steps.indices {
			if index == steps.count - 1 {
				break
			}
			
			let first = steps[index]
			let second = steps[index + 1]
			
			let firstPlacemark = MKPlacemark(coordinate: first, addressDictionary: nil)
			let secondPlacemark = MKPlacemark(coordinate: second, addressDictionary: nil)
			
			let firstMapItem = MKMapItem(placemark: firstPlacemark)
			let secondMapItem = MKMapItem(placemark: secondPlacemark)
			
			let directionRequest = MKDirectionsRequest()
			directionRequest.source = firstMapItem
			directionRequest.destination = secondMapItem
			directionRequest.transportType = .automobile
			directionRequest.requestsAlternateRoutes = true
			
			// Calculate the direction
			let directions = MKDirections(request: directionRequest)
			
			// 8.
			directions.calculate {
				(response, error) -> Void in
				self.calculatedStepsCount += 1
				
				guard let response = response else {
					if let error = error {
						print("Error: \(error)")
					}
					
					return
				}
				
				let route = response.routes[0]
				self.mapView.add(route.polyline, level: .aboveRoads)
				
				if self.calculatedStepsCount == steps.count - 1 {
					self.centerRegion()
				}
			}
		}
	}
	
	func centerRegion() -> Void {
		guard let steps = recordedSteps else {
			return
		}

		let totalCoord = steps.reduce((0, 0)) { (cumul, coordinate) -> (cumulLat: Double, cumulLong: Double) in
			return (cumulLat: cumul.0 + coordinate.latitude, cumulLong: cumul.1 + coordinate.longitude)
		}
		let middCoord = CLLocationCoordinate2D(latitude: totalCoord.0 / Double(steps.count), longitude: totalCoord.1 / Double(steps.count))
		
		var region = MKCoordinateRegion()
		region.center = middCoord
		
		var minLat: CLLocationDegrees = steps.first!.latitude
		var maxLat: CLLocationDegrees = steps.first!.latitude
		var minLong: CLLocationDegrees = steps.first!.longitude
		var maxLong: CLLocationDegrees = steps.first!.longitude
		for step in steps {
			if step.latitude < minLat {
				minLat = step.latitude
			}
			if step.latitude > maxLat {
				maxLat = step.latitude
			}
			if step.longitude < minLong {
				minLong = step.longitude
			}
			if step.longitude > maxLong {
				maxLong = step.longitude
			}
		}
		
		let spanDelta = max(maxLat - minLat, maxLong - minLong) + 0.01
		region.span.latitudeDelta = spanDelta
		region.span.longitudeDelta = spanDelta
		
		mapView.setRegion(region, animated: false)
	}
}
