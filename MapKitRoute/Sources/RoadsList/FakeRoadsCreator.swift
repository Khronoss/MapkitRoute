//
//  FakeRoadsCreator.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit

class FakeRoadsCreator: Any {
	class func fakeRoads() -> [Road] {
		return [
			firstRoad(),
			secondRoad(),
			thirdRoad(),
			fourthRoad()
		]
	}
	
	private class func firstRoad() -> Road {
		let coordinates: [Coordinate] = [
			Coordinate(latitude: 49.151793, longitude: 1.787538),
			Coordinate(latitude: 49.179572, longitude: 1.810568),
			Coordinate(latitude: 49.197607, longitude: 1.805720)
		]
		
		return Road(steps: coordinates, name: "Magny Magny~~")
	}
	
	private class func secondRoad() -> Road {
		let coordinates: [Coordinate] = [
			Coordinate(latitude: 49.025491, longitude: 1.979548),
			Coordinate(latitude: 49.031754, longitude: 1.998977),
			Coordinate(latitude: 49.028761, longitude: 2.022825),
			Coordinate(latitude: 49.010128, longitude: 2.032752),
			Coordinate(latitude: 49.012336, longitude: 2.094084),
			Coordinate(latitude: 49.008594, longitude: 2.155473)
		]
		
		return Road(steps: coordinates, name: "The big trip")
	}
	
	private class func thirdRoad() -> Road {
		let coordinates: [Coordinate] = [
			Coordinate(latitude: 48.944992, longitude: 2.567880),
			Coordinate(latitude: 48.948552, longitude: 2.592144),
			Coordinate(latitude: 48.937928, longitude: 2.596143),
			Coordinate(latitude: 48.935476, longitude: 2.572502),
			Coordinate(latitude: 48.941840, longitude: 2.569658)
		]
		
		return Road(steps: coordinates, name: "The circle")
	}
	
	private class func fourthRoad() -> Road {
		let coordinates: [Coordinate] = [
			Coordinate(latitude: 48.803310, longitude: 2.234054),
			Coordinate(latitude: 48.797205, longitude: 2.232237),
			Coordinate(latitude: 48.788537, longitude: 2.237035)
		]
		
		return Road(steps: coordinates, name: "Wavy mood")
	}
}
