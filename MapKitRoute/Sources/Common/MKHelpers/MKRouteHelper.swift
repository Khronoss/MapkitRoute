//
//  MKRouteHelper.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit
import MapKit

class MKRouteHelper: NSObject {
	private var operationQueue = OperationQueue()
	private var routes: [MKRoute] = []
	
	override init() {
		operationQueue.qualityOfService = .userInitiated
		
		super.init()
	}
	
	func requestRoutes(from coordinates: [Coordinate], completion: @escaping ([MKRoute]) -> Void) -> Void {
		guard coordinates.isEmpty == false else {
			completion([])
			return
		}
		
		for index in 0..<(coordinates.count - 1) {
			operationQueue.addOperation {
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
					self.routes.append(route)
				}
			}
		}
		
		operationQueue.waitUntilAllOperationsAreFinished()
		
		completion(routes)
	}
	
}

