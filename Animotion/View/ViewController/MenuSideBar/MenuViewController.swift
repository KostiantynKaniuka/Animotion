//
//  MenuViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 26.05.2023.
//

import UIKit

class MenuViewController: UIViewController {
    private let menuTableView = UITableView()

    var mockdata = ["one", "two", "three", "four"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UINib(nibName: "SideMenuCellTableViewCell", bundle: nil), forCellReuseIdentifier: SideMenuCellTableViewCell.sideMenuReuseId)
    }
    
    
    
    override func viewWillLayoutSubviews() {
      
        view.backgroundColor = .gray
        menuTableView.backgroundColor = .gray
        menuTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuTableView)
        NSLayoutConstraint.activate([
            menuTableView.topAnchor.constraint(equalTo: view.topAnchor),
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
     
    }
}

extension MenuViewController: UITableViewDelegate {
    
}

extension MenuViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCellTableViewCell.sideMenuReuseId) as? SideMenuCellTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = "Test "
        return cell
    }
}


