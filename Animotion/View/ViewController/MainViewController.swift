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
    private let carouselView = CarouselCollectionView()
    private let menu = SideMenuNavigationController(rootViewController: MenuViewController())
    private var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private lazy var pageView = carouselView.dots
    
   
  //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        carouselView.setUpMargins()
        carouselView.scrollToNextCell()
        menu.leftSide = true
        animateButtonAppearance()
    }

    override func viewWillLayoutSubviews() {
     setUpUI()
        carouselView.updateUi()
    
    }
    
    @IBAction func dreamButtonTapped(_ sender: UIButton) {
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func inspireButtonTapped(_ sender: UIButton) {
//        FireAPIManager.shared.addingDataToDb { error in
//            if error == nil {
//                print("data sended ✅")
//
//            } else {
//                print("failure to sent data", error)
//            }
//        }
        
//        FireAPIManager.shared.getCarouselDataFromdb { result in
//            print(result)
//        }
        carouselView.reloadData()
        carouselView.updateUi()
      
    }
    
    private func setUpUI() {
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(carouselView)
        view.addSubview(pageView)
        NSLayoutConstraint.activate([
            carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 250),
            
            pageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageView.topAnchor.constraint(equalTo: carouselView.bottomAnchor)
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

