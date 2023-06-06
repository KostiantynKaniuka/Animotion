//
//  CarouselCollectionVievModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 05.06.2023.
//

import Foundation

struct CarouselCollectionVievModel {
    let edgedistance: CGFloat = 30
    let cellsDistance: CGFloat = 40
    let cellHeight: Double = 150
    let cellWidgth: Double = 150
    var cellSize: CGSize {
        return CGSize(width: cellWidgth, height: cellHeight)
    }
    let numbersOfItems: Int = 5
     
    func fetchCarouselData() -> [CarouselData] {
           var cellsData: [CarouselData] = []
            FireAPIManager.shared.getCarouselDataFromdb { data in
             cellsData = data
                print("🍏", cellsData)
            }
           return cellsData
        }
    }

