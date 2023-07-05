//
//  MainViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 25.05.2023.
//

import UIKit
import SideMenu

class MainViewController: UIViewController {
    @IBOutlet weak var choosePathLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var relaxButton: UIButton!
    @IBOutlet weak var dreamButton: UIButton!
    @IBOutlet weak var inspireButton: UIButton!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var directionImageView: UIImageView!
    private let carouselView = CarouselCollectionView(layout: UICollectionViewFlowLayout())
    private let menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
    private var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private lazy var pageView = carouselView.dots
    
   
  //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animateButtonAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        carouselView.setUpMargins()
        carouselView.scrollToNextCell()
        menu.leftSide = true
        //menu.presentationStyle = .menuDissolveIn
    }

    override func viewWillLayoutSubviews() {
     setUpUI()
    }
    
    @IBAction func dreamButtonTapped(_ sender: UIButton) {
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func inspireButtonTapped(_ sender: UIButton) {
      show(VideoPlayer(), sender: self)
    }
    
    private func setUpUI() {
        view.backgroundColor = UIColor(red: 178/255, green: 236/255, blue: 197/255, alpha: 1)
        carouselView.view.translatesAutoresizingMaskIntoConstraints = false
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(carouselView.view)
        view.addSubview(pageView)
        NSLayoutConstraint.activate([
            carouselView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            carouselView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.view.heightAnchor.constraint(equalToConstant: 300),
            
            pageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageView.topAnchor.constraint(equalTo: carouselView.view.bottomAnchor)
        ])
        
    }
    

    private func animateButtonAppearance() {
  
        let buttonAnimations = [
            (button: profileButton, delay: 0.0),
            (button: dreamButton, delay: 0.5),
            (button: relaxButton, delay: 1.0),
            (button: focusButton, delay: 1.5),
            (button: inspireButton, delay: 2.0),
        ]
        directionImageView.alpha = 0.0
        
        for animation in buttonAnimations {
            animation.button?.alpha = 0.0 // Set initial alpha to 0

            UIView.animate(withDuration: 1, delay: animation.delay, animations: {
                animation.button?.alpha = 1.0 // Set final alpha to 1
            }, completion: { _ in
                DispatchQueue.main.async { [self] in
                   
                  impactFeedbackGenerator.prepare()
                  impactFeedbackGenerator.impactOccurred()
                }
            })
        }
        UIView.animate(withDuration: 1, delay: 2.5, animations: { [weak self] in
            self?.directionImageView.alpha = 1
        })
    }
}

