//
//  CarouselCollectionViewCell.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 01.06.2023.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    static let carouselCellId = "CarouselCell"
    
    let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zen")
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUi() {
        backgroundColor = .clear
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cellImage)
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellImage.topAnchor.constraint(equalTo: topAnchor),
            cellImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func transformToLarge() { // Make center cell larger
        self.layer.borderColor = UIColor.clear.cgColor
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.layer.borderWidth = 1.3
            
        }
    }
    
    func transformToStandart() { // return cell to origin state
        UIView.animate(withDuration: 0.2) {
            self.layer.borderWidth = 0
            self.transform = CGAffineTransform.identity
        }
    }
}
