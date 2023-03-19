//
//  NSLayoutConstraint + extension.swift
//  DogsApp
//
//  Created by Leeza on 13.03.2023.
//

import UIKit

extension NSLayoutConstraint {

    public class func useAndActivateConstraints(_ constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                 view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}
