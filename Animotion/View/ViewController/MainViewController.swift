//
//  MainViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 25.05.2023.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTapMoodButton()
}

class MainViewController: UIViewController {
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var relaxButton: UIButton!
    @IBOutlet weak var dreamButton: UIButton!
    @IBOutlet weak var inspireButton: UIButton!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var directionImageView: UIImageView!
    private var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    weak var delegate: MainViewControllerDelegate?
    
  
  //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateButtonAppearance()
    }

    
    @IBAction func dreamButtonTapped(_ sender: UIButton) {
        delegate?.didTapMoodButton()
    }
    
    @IBAction func inspireButtonTapped(_ sender: UIButton) {
        delegate?.didTapMoodButton()
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
                DispatchQueue.main.async {
                   
                    self.impactFeedbackGenerator.prepare()
                    self.impactFeedbackGenerator.impactOccurred()
                }
            })
        }
        UIView.animate(withDuration: 1, delay: 2.5, animations: {
            self.directionImageView.alpha = 1
        })
    }
}