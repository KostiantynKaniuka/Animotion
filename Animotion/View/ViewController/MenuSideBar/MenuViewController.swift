//
//  MenuViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 26.05.2023.
//

import UIKit
import Kingfisher

class MenuViewController: UIViewController {
    private let menuTableView = UITableView()
    private let topView = UIView()
    private let videoPlayer = VideoPlayer()
    private let viewModel = SideMenuViewModel()
    private var tableViewData = [SideMenu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getSideMenuData()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UINib(nibName: "SideMenuCellTableViewCell", bundle: nil), forCellReuseIdentifier: SideMenuCellTableViewCell.sideMenuReuseId)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        view.backgroundColor = .menuBacgtoundColor
        menuTableView.backgroundColor = .clear
        
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuTableView)
        NSLayoutConstraint.activate([
            menuTableView.topAnchor.constraint(equalTo: view.topAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
     
    }
    
    private func setupUi() {
        
    }
}

extension MenuViewController: UITableViewDelegate {
    
}

extension MenuViewController: UITableViewDataSource {
    
 
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCellTableViewCell.sideMenuReuseId) as? SideMenuCellTableViewCell else { return UITableViewCell() }
        let url = URL(string: tableViewData[indexPath.row].image)
        cell.cellImage.kf.setImage(with: url)
        cell.cellImage.backgroundColor = .black
        cell.titleLabel.text = tableViewData[indexPath.row].name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
       
    }
}

extension MenuViewController: SideMenuDataDelegate {
    func sideMenuDataLoaded(data: [SideMenu]) {
        tableViewData = data
        menuTableView.reloadData()
    }
}
