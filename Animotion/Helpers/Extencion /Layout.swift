//
//  Layout.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.07.2023.
//

import UIKit

extension UIView {
    
    func add(subviews: UIView...) {
        for subview in subviews {
            self.addSubview(subview)
        }
    }
}

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
