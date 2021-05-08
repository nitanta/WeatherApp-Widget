//
//  ViewType.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/8/21.
//

import UIKit

enum ViewType: CaseIterable {
    case small
    case medium
    case large
    
    var containerSize: CGSize {
        switch self {
        case .small: return CGSize(width: 155, height: 155)
        case .medium:  return CGSize(width: 330, height: 155)
        case .large:  return CGSize(width: 330, height: 345)
        }
    }
    
    var imageSize: CGSize {
        switch self {
        case .small: return CGSize(width: 67, height: 67)
        case .medium:  return CGSize(width: 82, height: 82)
        case .large:  return CGSize(width: 155, height: 155)
        }
    }
    
    var imageLeading: CGFloat {
        switch self {
        case .small: return self.containerSize.width / 2 - self.imageSize.width / 2
        case .medium: return 16
        case .large:  return self.containerSize.width / 2 - self.imageSize.width / 2
        }
    }
    
    var imageTop: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 16
        case .large:  return 48
        }
    }
    
    var labelFontSize: CGFloat {
        switch self {
        case .small: return 18
        case .medium: return 24
        case .large:  return 32
        }
    }
}
