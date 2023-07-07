//
//  MenuViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 26.05.2023.
//

import UIKit
import Kingfisher

protocol VideoLinkDelegate: AnyObject {
    func sendTheLink(_ link: String, title: String, location: String)
}

final class SideMenuViewController: UIViewController {
    private let menuTableView = UITableView()
    private let profileImage = UIImageView()
    private let profileLabel = UILabel()
    private let topView = UIView()
    private let viewModel = SideMenuViewModel()
    private var ukraineSection = [UkraineSection]()
    private var safeSpaceSection = [SafeSpace]()
    private var dataSource = [Section]()
    weak var linkDelegate: VideoLinkDelegate?

    enum Section {
        case ukraine(items: [UkraineSection])
        case safeSpace(items: [SafeSpace])
        
        var title: String {
            switch self {
            case .ukraine:
                return "Ukraine"
            case .safeSpace:
                return "Safe space"
            }
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.tableHeaderView = nil
        menuTableView.delegate = self
        menuTableView.dataSource = self
        viewModel.ukraineDelegate = self
        viewModel.safeSpaceDelegate = self
        viewModel.getUkraineSideMenuData()
        viewModel.getSafeSpaceSideMenuData()
        menuTableView.register(UINib(nibName: "SideMenuCellTableViewCell", bundle: nil), forCellReuseIdentifier: SideMenuCellTableViewCell.sideMenuReuseId)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     setupUi()
    }
}

//MARK: - TableView Delegate
extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = dataSource[indexPath.section]
        switch section {
        case .ukraine(items: let items):
            linkDelegate?.sendTheLink(items[indexPath.row].videoLink, title: items[indexPath.row].name, location: items[indexPath.row].location)
        case .safeSpace(items: let items):
            linkDelegate?.sendTheLink(items[indexPath.row].videoLink, title: items[indexPath.row].name, location: "")
        }
    }
}

//MARK: - DataSource
extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationController?.setNavigationBarHidden(true, animated: true) // hide nav bar when scrolling
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                   section: Int) -> String? {
        return dataSource[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataSource[section] {
        case .ukraine(items: let items):
            return items.count
        case .safeSpace(items: let items):
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = dataSource[indexPath.section]
        switch section {
        case .ukraine(items: let items):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCellTableViewCell.sideMenuReuseId) as? SideMenuCellTableViewCell else { return UITableViewCell()}
            let url = URL(string: items[indexPath.row].image)
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url, options: [.cacheOriginalImage, .transition(.fade(1))])
            cell.cellImage.backgroundColor = .black
            cell.titleLabel.text = items[indexPath.row].name
            
            return cell
            
        case .safeSpace(items: let items):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCellTableViewCell.sideMenuReuseId) as? SideMenuCellTableViewCell else { return UITableViewCell()}
            let url = URL(string: items[indexPath.row].image)
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url, options: [.cacheOriginalImage, .transition(.fade(1))])
            cell.cellImage.backgroundColor = .black
            cell.titleLabel.text = items[indexPath.row].name
            
            return cell
        }
    }
    
}

private extension SideMenuViewController {
    
    func createDataSource() -> [Section] {
        let ukraineItems = Section.ukraine(items: ukraineSection)
        let safeSpaceItems = Section.safeSpace(items: safeSpaceSection)
        
        return [ukraineItems, safeSpaceItems]
    }
}

extension SideMenuViewController: UkraineMenuDataDelegate {
    
    func ukraineSideMenuDataLoaded(data: [UkraineSection]) {
        ukraineSection = data
        dataSource = createDataSource()
        menuTableView.reloadData()
        
    }
}

extension SideMenuViewController: SafeSpaceDataDelegate {
    
    func safeSpaceDataLoaded(data: [SafeSpace]) {
        safeSpaceSection = data
        dataSource = createDataSource()
        menuTableView.reloadData()
    }
}

//MARK: - UI
extension SideMenuViewController {
    
    private func setupUi() {
        view.backgroundColor = .systemGray
        
        menuTableView.backgroundColor = .menuBacgtoundColor
        menuTableView.separatorStyle = .none
        menuTableView.showsVerticalScrollIndicator = false
        
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
