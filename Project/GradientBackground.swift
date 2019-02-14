 //
//  GradientBackground.swift
//  Project
//
//  Created by Ростислав Нурдинов on 08.02.19.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor, colorThree.cgColor]
        gradientLayer.locations = [0.1, 0.1, 0.9]
        gradientLayer.startPoint = CGPoint(x: 0.7, y: 0.7)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setGradientWindow(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.4, 0.9]
        gradientLayer.startPoint = CGPoint(x: 1.7, y: 1.7)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
