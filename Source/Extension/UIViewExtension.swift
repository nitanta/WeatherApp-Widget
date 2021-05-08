//
//  UIViewExtension.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/8/21.
//

import UIKit

extension UIView {
    /// Adds drop shadow to the view
    /// - Parameter cornerRadius: Corner radius, CGFloat
    func dropShadow(cornerRadius: CGFloat) {
        let shadowLayer = CAShapeLayer()
        
        layer.cornerRadius = cornerRadius
        shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: layer.cornerRadius).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowOffset = CGSize(width: -2, height: 2)
        shadowLayer.shadowOpacity = 0.4
        shadowLayer.shadowRadius = 2.0
        layer.insertSublayer(shadowLayer, at: 0)
    }
}
