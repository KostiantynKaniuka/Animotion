//
//  CarouselFlowLayout.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 05.06.2023.
//

import UIKit

class CarouselFlowLayout: UICollectionViewFlowLayout {
    let spaceBetweenCell: CGFloat
    let spaceToSuperView: CGFloat
    
    
    
    init(spaceBetweenCell: CGFloat, spaceToSuperView: CGFloat) {
        self.spaceBetweenCell = spaceBetweenCell
        self.spaceToSuperView = spaceToSuperView
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumLineSpacing = spaceBetweenCell
        minimumInteritemSpacing = spaceBetweenCell
    }
    
}
