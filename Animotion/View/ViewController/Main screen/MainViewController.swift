//
//  MainViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 25.05.2023.
//

import UIKit
import SideMenu
import SnapKit

final class MainViewController: UIViewController {
    @IBOutlet weak var dreamButton: UIButton!
    private let sideMenu = SideMenuViewController()
    let chartView = ChartView()
    //private let carouselView = CarouselCollectionView(layout: UICollectionViewFlowLayout())
    lazy var menu = SideMenuNavigationController(rootViewController: sideMenu)
    private var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    // private lazy var pageView = carouselView.dots
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu.linkDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // carouselView.setUpMargins()
        //carouselView.scrollToNextCell()
        menu.leftSide = true
    }
    
    override func viewWillLayoutSubviews() {
        setUpConstraints()
    }
    
    @IBAction func dreamButtonTapped(_ sender: UIButton) {
        present(menu, animated: true, completion: nil)
    }
}
    
 
extension MainViewController: VideoLinkDelegate {
    
    func sendTheLink(_ link: String, title: String, location: String) {
       let videoPlayer = VideoPlayer()
            videoPlayer.videoTitle = title
        videoPlayer.link = "https://www.pexels.com/pl-pl/download/video/16757506/"
            videoPlayer.videoSubtitle = location
        sideMenu.dismiss(animated: true)
        videoPlayer.modalPresentationStyle = .fullScreen
        navigationController?.present(videoPlayer, animated: true)
        }
}

extension MainViewController {
    
    private func setUpConstraints() {
        view.backgroundColor = UIColor(red: 178/255, green: 236/255, blue: 197/255, alpha: 1)
    
      
        view.addSubview(chartView.view)
        chartView.view.snp.makeConstraints { make in
            make.height.equalTo(CGFloat(400))
            make.left.right.equalToSuperview().inset(16)
            make.center.equalToSuperview()
            }
        }
    

        
//        carouselView.view.translatesAutoresizingMaskIntoConstraints = false
//        pageView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(carouselView.view)
//        view.addSubview(pageView)
//        NSLayoutConstraint.activate([
//            carouselView.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            carouselView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            carouselView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            carouselView.view.heightAnchor.constraint(equalToConstant: 300),
//
//            pageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            pageView.topAnchor.constraint(equalTo: carouselView.view.bottomAnchor)
//        ])
    }

