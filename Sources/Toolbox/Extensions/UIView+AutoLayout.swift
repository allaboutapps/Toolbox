//
//  File.swift
//  
//
//  Created by Oliver Krakora on 06.11.20.
//

import UIKit

extension UIView {
    
    /// Adds `self` to `view` as a subview and applies constraints to all edges
    /// - Parameter view: The superview to which the view should be added as a subview
    /// - Parameter offset: The offset that should be applied to all edges of the subview
    func pin(to view: UIView, offset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset.left),
            topAnchor.constraint(equalTo: view.topAnchor, constant: offset.top),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: offset.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offset.bottom)
        ])
    }

    /// Adds `view` to `self` as a subview and applies constraints to all edges
    /// - Parameter view: The subview that should be added to the superview
    /// - Parameter offset: The offset that should be applied to all edges of the subview
    func wrap(view: UIView, offset: UIEdgeInsets = .zero) {
        view.pin(to: self, offset: offset)
    }
}
