//
//  LoginTextfiel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.07.2023.
//

import UIKit

final class LoginTextfiel: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        textFieldSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func textFieldSettings() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.font = UIFont(name: "SanFrancisco", size: 17)
        self.textAlignment = .left
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        self.layer.shadowOpacity = 1.0
        self.textColor = .black
        self.setLeftPaddingPoints(8)
        self.setRightPaddingPoints(8)
    }
}
