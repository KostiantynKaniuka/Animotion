//
//  SideMenuViewModel.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 04.07.2023.
//

import Foundation

protocol UkraineMenuDataDelegate: AnyObject {
    func ukraineSideMenuDataLoaded(data: [UkraineSection])
}

protocol SafeSpaceDataDelegate: AnyObject {
    func safeSpaceDataLoaded(data: [SafeSpace])
}

final class SideMenuViewModel {
    weak var ukraineDelegate: UkraineMenuDataDelegate?
    weak var safeSpaceDelegate: SafeSpaceDataDelegate?
    
    func getUkraineSideMenuData() {
        FireAPIManager.shared.getUkraineMenuData { [weak self] result in
            DispatchQueue.main.async {
                self?.ukraineDelegate?.ukraineSideMenuDataLoaded(data: result)
            }
        }
    }
    
    func getSafeSpaceSideMenuData() {
        FireAPIManager.shared.getSafeSpaceMenuData { [weak self] result in
            DispatchQueue.main.async {
                self?.safeSpaceDelegate?.safeSpaceDataLoaded(data: result)
            }
        }
    }
    
}
