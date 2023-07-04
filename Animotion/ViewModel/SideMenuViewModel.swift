//
//  SideMenuViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 04.07.2023.
//

import Foundation

protocol SideMenuDataDelegate: AnyObject {
    func sideMenuDataLoaded(data: [SideMenu])
}

final class SideMenuViewModel {
    private let firebaseManager = FireAPIManager()
    var sideMenuData: [SideMenu] = []
    weak var delegate: SideMenuDataDelegate?
    
    func getSideMenuData() {
        firebaseManager.getSideMenuData { [weak self] result in
            DispatchQueue.main.async {
                self?.delegate?.sideMenuDataLoaded(data: result)
            }
        }
    }
}
