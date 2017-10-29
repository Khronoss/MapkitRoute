//
//  SavedRoadsService.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit

class SavedRoadsService: NSObject {
	private var userDefaults = UserDefaults.standard
	private let roadKey = "saved_roads"
	
	private func jsonSavedRoads() -> [ [String: Any] ] {
		let jsonRoads = userDefaults.array(forKey: roadKey) as? [ [String: Any] ]
		
		return jsonRoads ?? []
	}
	
	func savedRoads() -> [Road] {
		let jsonRoads = jsonSavedRoads()
		
		return JSONToRoads(jsonRoads)
	}
	
	func addRoad(_ road: Road) {
		var savedRoads = self.jsonSavedRoads()
		let jsonRoad = roadToJSON(road)
		
		savedRoads.append(jsonRoad)
		
		userDefaults.set(savedRoads, forKey: roadKey)
		userDefaults.synchronize()
	}
}

private extension SavedRoadsService {
	func roadsToJSON(_ roads: [Road]) -> [ [String: Any] ] {
		return roads.map({ (road) -> [String: Any] in
			return self.roadToJSON(road)
		})
	}

	func roadToJSON(_ road: Road) -> [String: Any] {
		let jsonSteps = road.steps.map({ (coordinate) -> [String: Any] in
			return [
				"lat": coordinate.latitude,
				"long": coordinate.longitude
			]
		})
		
		return [
			"name": road.name,
			"steps": jsonSteps
		]
	}
	
	func JSONToRoads(_ json: [ [String: Any] ]) -> [Road] {
		return json.map({ (jsonRoad) -> Road in
			return self.JSONToRoad(jsonRoad)
		})
	}

	func JSONToRoad(_ json: [String: Any]) -> Road {
		let name = json["name"] as! String
		let jsonSteps = json["steps"] as! [ [String: Any] ]
		
		let steps = jsonSteps.map({ (jsonStep) -> Coordinate in
			let lat = jsonStep["lat"] as! Double
			let long = jsonStep["long"] as! Double
			
			return Coordinate(latitude: lat, longitude: long)
		})
		
		return Road(steps: steps, name: name)
	}
}
