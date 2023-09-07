//
//  CustomLabel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 18.07.2023.
//

import UIKit


final class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        labelSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func labelSettings() {
        self.font = UIFont.systemFont(ofSize: 13)
        self.textColor = .systemRed
        self.numberOfLines = 1
        self.textAlignment = .left
    }
}
    
    
    

