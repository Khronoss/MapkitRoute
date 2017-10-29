//
//  Road.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit
import MapKit

typealias Coordinate = CLLocationCoordinate2D

struct Road {
	let steps: [Coordinate]
	let name: String
}
