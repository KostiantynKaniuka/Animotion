//
//  CarouselCollectionVievModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 05.06.2023.
//

import UIKit

protocol CarouselCollectionViewDelegate: AnyObject {
    func carouselDataLoaded(data: [CarouselData])
}

final class CarouselCollectionVievModel {
    var carouselData: [CarouselData] = []
    let edgedistance: CGFloat = 30
    let cellsDistance: CGFloat = 40
    let cellHeight: Double = 200
    let cellWidgth: Double = 150
    var cellSize: CGSize {
        return CGSize(width: cellWidgth, height: cellHeight)
    }
    weak var delegate: CarouselCollectionViewDelegate?

    func loadCarouselData() {
           FireAPIManager().getCarouselDataFromdb { [weak self] data in
               DispatchQueue.main.async {
                   self?.delegate?.carouselDataLoaded(data: data)
               }
           }
       }
    
    func openUrl(myUrl: String) {
        if let url = URL(string: myUrl) {
            UIApplication.shared.open(url)
        }
    }
    }
