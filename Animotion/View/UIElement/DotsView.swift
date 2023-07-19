//
//  DotsView.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 05.06.2023.
//

import UIKit

class DotsView: UIPageControl {
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
       pageIndicatorTintColor = .systemGray
       currentPageIndicatorTintColor = .systemGreen
    }
}
