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
    func addShadow(with cornerRadius: CGFloat, color: UIColor = .black, radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1.0
        layer.borderColor = color.withAlphaComponent(0.2).cgColor
        
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}
