//
//  MainViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 25.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var relaxButton: UIButton!
    @IBOutlet weak var dreamButton: UIButton!
    @IBOutlet weak var inspireButton: UIButton!
    @IBOutlet weak var focusButton: UIButton!
    private var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateButtonAppearance()
    }

   
    private func animateButtonAppearance() {
        let buttonAnimations = [
            (button: profileButton, delay: 0.0),
            (button: dreamButton, delay: 0.5),
            (button: relaxButton, delay: 1.0),
            (button: focusButton, delay: 1.5),
            (button: inspireButton, delay: 2.0)
        ]
        
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
        }    }
}
