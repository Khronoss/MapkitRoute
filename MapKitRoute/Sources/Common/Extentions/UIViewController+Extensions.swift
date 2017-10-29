//
//  UIViewController+Extensions.swift
//  MapKitRoute
//
//  Created by Anthony Merle on 29/10/2017.
//  Copyright © 2017 Anthony Merle. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func dismiss() -> Void {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
