//
//  CarouselCollectionView.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 01.06.2023.
//

import UIKit
import Kingfisher

class CarouselCollectionView: UICollectionViewController {
    private let viewModel = CarouselCollectionVievModel()
    private var centerCell: CarouselCollectionViewCell?
    private var layout = UICollectionViewFlowLayout()
    private var collectionViewData: [CarouselData] = []
    var dots = DotsView()
    
    
    init(layout: UICollectionViewFlowLayout) {
        self.layout = layout
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadCarouselData()
        setUpUI()
    }
   
    func scrollToNextCell(){
        let cellSize = CGSizeMake(viewModel.cellWidgth, viewModel.cellHeight)
        let contentOffset = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
      }
    
    private func setUpUI() {
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = .clear
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.carouselCellId)
        layout.minimumLineSpacing = viewModel.cellsDistance// space between cells
        collectionView.contentInset.right = viewModel.edgedistance // space fron edge from superview to collection view
        collectionView.contentInset.left = viewModel.edgedistance
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func setUpMargins() {
        let layoutMargins: CGFloat = collectionView.layoutMargins.left + collectionView.layoutMargins.right
        let sideInsert = (collectionView.frame.width / 2) - layoutMargins
        collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInsert, bottom: 0, right: sideInsert)
    }
}



//MARK: - Scrollview
extension CarouselCollectionView {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else {return}
        dots.currentPage = Int(
            (collectionView.contentOffset.x / viewModel.cellWidgth)
               .rounded(.toNearestOrAwayFromZero)
           )// seting dots on page contol
        let centerPoint = CGPoint(x: collectionView.frame.size.width / 2 + scrollView.contentOffset.x , y: collectionView.frame.size.height / 2 + scrollView.contentOffset.y) // checking center of collection view
        if let selecredIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            self.centerCell = (collectionView.cellForItem(at: selecredIndexPath) as? CarouselCollectionViewCell)
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

//MARK: - CollectionView Layout
extension CarouselCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize
    }
    
}


extension CarouselCollectionView {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = collectionViewData[indexPath.row].linkToBlog
        viewModel.openUrl(myUrl: url)
    }
}
//MARK: - Data source
extension CarouselCollectionView {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dots.numberOfPages = collectionViewData.count
        return collectionViewData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.carouselCellId, for: indexPath) as? CarouselCollectionViewCell else { return UICollectionViewCell() }
        let url = URL(string: collectionViewData[indexPath.row].imageUrl)
        cell.cellTitle.text = collectionViewData[indexPath.row].descriptionText
       cell.cellImage.kf.setImage(with: url)
        return  cell
    }
}

//MARK: - Flow Layouyt
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

extension CarouselCollectionView: CarouselCollectionViewDelegate {
    
    func carouselDataLoaded(data: [CarouselData]) {
        collectionViewData = data
        collectionView.reloadData()
    }
}
