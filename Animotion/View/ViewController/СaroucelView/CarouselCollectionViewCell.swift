//
//  CarouselCollectionViewCell.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 01.06.2023.
//

import UIKit
import Kingfisher

final class CarouselCollectionViewCell: UICollectionViewCell {
    static let carouselCellId = "CarouselCell"
    let cellTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        
        return label
    }()
    
    let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15.0
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor =  UIColor.white.cgColor
       // imageView.layer.borderColor?.alpha = 0.5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
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
        cellImage.alpha = 0.4
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cellImage)
        addSubview(cellTitle)
     
        NSLayoutConstraint.activate([
            cellTitle.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            cellTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cellTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellImage.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            cellImage.bottomAnchor.constraint(equalTo: bottomAnchor)
            
            
        ])
        cellTitle.isHidden = true
    }
    
    func transformToLarge() { // Make center cell larger
        self.layer.borderColor = UIColor.clear.cgColor
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self?.layer.borderWidth = 1.3
            self?.cellImage.alpha = 1.0
            self?.cellTitle.isHidden = false
        }
    }
    
    func transformToStandart() { // return cell to origin state
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layer.borderWidth = 0
            self?.transform = CGAffineTransform.identity
            self?.cellImage.alpha = 0.4
            self?.cellTitle.isHidden = true
        }
    }
}
