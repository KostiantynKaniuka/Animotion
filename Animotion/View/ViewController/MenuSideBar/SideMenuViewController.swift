//
//  MenuViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 26.05.2023.
//

import UIKit
import Kingfisher

class SideMenuViewController: UIViewController {
    private let menuTableView = UITableView()
    private let profileImage = UIImageView()
    private let profileLabel = UILabel()
    private let topView = UIView()
    private let videoPlayer = VideoPlayer()
    private let viewModel = SideMenuViewModel()
    private var tableViewData = [SideMenu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.tableHeaderView = nil
        viewModel.delegate = self
        viewModel.getSideMenuData()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UINib(nibName: "SideMenuCellTableViewCell", bundle: nil), forCellReuseIdentifier: SideMenuCellTableViewCell.sideMenuReuseId)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     setupUi()
    }
    
    private func setupUi() {
        view.backgroundColor = .systemGray
        menuTableView.backgroundColor = .menuBacgtoundColor
        topView.backgroundColor = .menuBacgtoundColor
        profileLabel.textColor = .white
        profileLabel.text = "Hey! Where we going today?"
        profileLabel.textColor = .lightGray
        profileLabel.numberOfLines = 0
        profileLabel.font = UIFont(name: "San Francisco", size: 6)
        
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.image = UIImage(named: "back 1")
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.frame.size = CGSize(width: 300, height: 100)
        let borderLayer = CALayer()
            borderLayer.backgroundColor = UIColor.white.cgColor
        borderLayer.frame = CGRect(x: 0, y: 150, width: topView.bounds.width, height: 2)
            topView.layer.addSublayer(borderLayer)
        profileImage.frame.size = CGSize(width: 50, height: 50)
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(topView)
        topView.addSubview(profileImage)
        topView.addSubview(profileLabel)
        view.addSubview(menuTableView)
     
       
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        
        NSLayoutConstraint.activate([
            profileImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            profileImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
                   profileImage.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            menuTableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profileLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            profileLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            profileLabel.widthAnchor.constraint(equalToConstant: 150)
            
            
        ])
    }
}

extension SideMenuViewController: UITableViewDelegate {
    
}

extension SideMenuViewController: UITableViewDataSource {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationController?.setNavigationBarHidden(true, animated: true) // hide nav bar when scrolling
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCellTableViewCell.sideMenuReuseId) as? SideMenuCellTableViewCell else { return UITableViewCell() }
        let url = URL(string: tableViewData[indexPath.row].image)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, options: [.cacheOriginalImage, .transition(.fade(1))])
        cell.cellImage.backgroundColor = .black
        cell.titleLabel.text = tableViewData[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
       
    }
}

extension SideMenuViewController: SideMenuDataDelegate {
    func sideMenuDataLoaded(data: [SideMenu]) {
        tableViewData = data
        menuTableView.reloadData()
    }
}
