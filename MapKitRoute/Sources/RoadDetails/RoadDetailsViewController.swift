//
//  RoadDetailsViewController.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit
import MapKit

class RoadDetailsViewController: UIViewController {
	var road: Road!
	private var coordinates: [Coordinate] {
		return road.steps
	}
	
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		title = road.name
		
		calculatePaths()
		addAnnotations()
		setRegion()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	private func calculatePaths() {
		for index in coordinates.indices {
			if index == coordinates.count - 1 {
				break
			}
			
			let first = coordinates[index]
			let second = coordinates[index + 1]
			
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
				
				guard let response = response else {
					if let error = error {
						print("Error: \(error)")
					}
					
					return
				}
				
				let route = response.routes[0]
				self.mapView.add(route.polyline, level: .aboveRoads)
			}
		}
	}
	
	private func addAnnotations() {
		let annotations = coordinates.map { (coordinate) -> MKPointAnnotation in
			let annotation = MKPointAnnotation()
			
			annotation.coordinate = coordinate
			
			return annotation
		}
		mapView.showAnnotations(annotations, animated: false)
	}
	
	private func setRegion() {
		let totalCoord = coordinates.reduce((0, 0)) { (cumul, coordinate) -> (cumulLat: Double, cumulLong: Double) in
			return (cumulLat: cumul.0 + coordinate.latitude, cumulLong: cumul.1 + coordinate.longitude)
		}
		let middCoord = CLLocationCoordinate2D(latitude: totalCoord.0 / Double(coordinates.count), longitude: totalCoord.1 / Double(coordinates.count))
		
		var region = MKCoordinateRegion()
		region.center = middCoord
		
		var minLat: CLLocationDegrees = coordinates.first!.latitude
		var maxLat: CLLocationDegrees = coordinates.first!.latitude
		var minLong: CLLocationDegrees = coordinates.first!.longitude
		var maxLong: CLLocationDegrees = coordinates.first!.longitude
		for step in coordinates {
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

extension RoadDetailsViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay: overlay)
		renderer.strokeColor = UIColor.red
		renderer.lineWidth = 4.0
		
		return renderer
	}

}
