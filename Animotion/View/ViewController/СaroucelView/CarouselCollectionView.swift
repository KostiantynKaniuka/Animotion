//
//  CarouselCollectionView.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 01.06.2023.
//

import UIKit

class CarouselCollectionView: UICollectionView {
    private var centerCell: CarouselCollectionViewCell?
    private let layout = UICollectionViewFlowLayout()
     var dots = DotsView()
    let viewModel = CarouselCollectionVievModel()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
       
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToNextCell(){
        let cellSize = CGSizeMake(viewModel.cellWidght, viewModel.cellHeight)
          let contentOffset = contentOffset
          scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);

      }
    

    private func setUpUI() {
        layout.scrollDirection = .horizontal
        delegate = self
        dataSource = self
        backgroundColor = .clear
        register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.carouselCellId)
        layout.minimumLineSpacing = viewModel.cellsDistance// space between cells
        contentInset.right = viewModel.edgedistance // space fron edge from superview to collection view
        contentInset.left = viewModel.edgedistance
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    func setUpMargins() {
        let layoutMargins: CGFloat = self.layoutMargins.left + self.layoutMargins.right
        let sideInsert = (self.frame.width / 2) - layoutMargins
        self.contentInset = UIEdgeInsets(top: 0, left: sideInsert, bottom: 0, right: sideInsert)
    }
}


extension CarouselCollectionView: UICollectionViewDelegate {
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else {return}
        dots.currentPage = Int(
            (self.contentOffset.x / viewModel.cellWidght)
               .rounded(.toNearestOrAwayFromZero)
           )// seting dots on page contol
        let centerPoint = CGPoint(x: self.frame.size.width / 2 + scrollView.contentOffset.x , y: self.frame.size.height / 2 + scrollView.contentOffset.y) // checking center of collection view
        print(centerPoint)
     
        
        if let selecredIndexPath = self.indexPathForItem(at: centerPoint) {
            self.centerCell = (self.cellForItem(at: selecredIndexPath) as? CarouselCollectionViewCell)
            centerCell?.transformToLarge()
           
        }
        
        if let cell = self.centerCell {
            let offsetX = centerPoint.x - cell.center.x
            
            if offsetX < -70 || offsetX > 70 {
                cell.transformToStandart()
                self.centerCell = nil // set to nil to let other cells enter the above scope
            }
        }
    }
}

extension CarouselCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize
    }
    
}

extension CarouselCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dots.numberOfPages = viewModel.numbersOfItems
        return viewModel.numbersOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.carouselCellId, for: indexPath) as? CarouselCollectionViewCell else { return UICollectionViewCell() }

        return  cell
    }
}


extension UICollectionViewFlowLayout {

    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
            let horizontalOffset = proposedContentOffset.x + collectionView!.contentInset.left
            let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
            let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
            layoutAttributesArray?.forEach({ (layoutAttributes) in
                let itemOffset = layoutAttributes.frame.origin.x
                if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                    offsetAdjustment = itemOffset - horizontalOffset
                }
            })
            return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)

    }
}
