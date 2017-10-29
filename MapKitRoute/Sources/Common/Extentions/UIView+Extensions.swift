//
//  UIView+Extensions.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit

extension UIView {
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			guard circleEdges == false else {
				return
			}
			layer.cornerRadius = newValue
		}
	}
	
	@IBInspectable var circleEdges: Bool {
		get {
			return layer.cornerRadius * 2 == bounds.height
		}
		set {
			layer.cornerRadius = bounds.height / 2
		}
	}
}
