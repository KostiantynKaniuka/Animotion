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
    let cellWidght: Double = 150
    var cellSize: CGSize {
        return CGSize(width: cellWidght, height: cellHeight)
    }
    let numbersOfItems: Int = 5
}
