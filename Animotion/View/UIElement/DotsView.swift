//
//  DotsView.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 05.06.2023.
//

import UIKit

final class DotsView: UIPageControl {
    
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


final class DevideView: UIView {
    
    init() {
        super.init(frame: .zero)
        viewSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func viewSettings() {
        self.frame.size = CGSize(width: 70, height: 1)
        self.backgroundColor = .lightGray
    }
    
}
