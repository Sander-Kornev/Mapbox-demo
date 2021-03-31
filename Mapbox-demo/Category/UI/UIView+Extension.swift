//
//  UIView+Extension.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import UIKit

extension UIView {
    
    func addConstraints(withVFL items: [String], options: NSLayoutConstraint.FormatOptions, metrics: [String: Any]?, views: [String: Any]) {
        
        addConstraints(
            items
                .map { NSLayoutConstraint.constraints(withVisualFormat: $0, options: options, metrics: metrics, views: views) }
                .flatMap { $0 }
        )
    }
    
    func addFullscreenConstraints(for subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        //add autolayout constraints
        let views = ["subview": subview]
        addConstraints(withVFL: ["|[subview]|",
                                 "V:|[subview]|"],
                       options: [.alignAllCenterX,
                                 .alignAllCenterY],
                       metrics: nil,
                       views: views)
    }
}
