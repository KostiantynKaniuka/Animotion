//
//  MoodCaptureViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.08.2023.
//

import UIKit
import SnapKit

final class MoodCaptureViewController: UIViewController, UIPickerViewDelegate {
    
    private let scrollView = UIScrollView()
    private let backgroundImage = UIImageView()
    private let contentView = UIView()
    private let pickersSection = UIView()
    private let moodPickerView = UIPickerView()
    private let mentalStatePickerView = UIPickerView()
    private let descriptionLabel = UILabel()
    private let reasonLabel = UILabel()
    private let moodDescriptionLabel = UILabel()
    private let dividerView = UIView()
    private let mentalDescriptionLabel = UILabel()
    private let buttonsStack = UIStackView()
    private let reasonTextField = CustomTextField()
    private let submitButton = SubmitButton()
    private let cancelButton = CancelCaptureButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Capture mood here"
        mentalStatePickerView.dataSource = self
        mentalStatePickerView.delegate = self
        moodPickerView.delegate = self
        moodPickerView.dataSource = self
        view.backgroundColor = .white
        setUpLayout()
        applyUISettings()
    }


}


extension MoodCaptureViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Test"
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "Test", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    
    
}

//MARK: - Layout
extension MoodCaptureViewController {
    
    private func setUpLayout() {
        view.add(subviews: backgroundImage,
                 scrollView)
       
        scrollView.addSubview(contentView)
        
        buttonsStack.addArrangedSubview(submitButton)
        buttonsStack.addArrangedSubview(cancelButton)
        
        pickersSection.add(subviews: mentalStatePickerView,
                           moodPickerView,
                           moodDescriptionLabel,
                           mentalDescriptionLabel,
                           dividerView)
        
        contentView.add(subviews: pickersSection,
                        descriptionLabel,
                        reasonLabel,
                        reasonTextField,
                        buttonsStack)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.scrollView)
            make.left.right.equalTo(self.view)
            make.width.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
            
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
        
        pickersSection.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 300))
            make.left.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        
        }
        
        moodDescriptionLabel.snp.makeConstraints { make in
           make.left.equalToSuperview().offset(8)
            make.centerY.equalTo(moodPickerView)
            make.right.equalTo(moodPickerView.snp.left).offset(-8)
        }

        mentalDescriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalTo(mentalStatePickerView)
            make.right.equalTo(mentalStatePickerView.snp.left).offset(-8)
        }
        
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.right.left.equalToSuperview()
        }

        moodPickerView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 200, height: 100))
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().offset(-8)
        }

        mentalStatePickerView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 200, height: 100))
            make.bottom.equalToSuperview().offset(-16)
            make.right.equalToSuperview().offset(-8)
        }

        reasonLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
            make.top.equalTo(pickersSection.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }

        reasonTextField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 40))
            make.centerX.equalTo(reasonLabel)
            make.top.equalTo(reasonLabel.snp.bottom)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.centerX.equalTo(reasonTextField)
            make.top.equalTo(reasonTextField.snp.bottom).offset(16)
        }

        submitButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
        }

        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
    }

    private func applyUISettings() {
        backgroundImage.image =             UIImage(named: "backtest")
        moodPickerView.layer.cornerRadius = 10
        mentalStatePickerView.layer.cornerRadius = 10
        
        moodDescriptionLabel.text = "Please rate your mood from 1 to 10 where: \n1 - Horrible, \n10 - Wonderful."
        moodDescriptionLabel.numberOfLines = 0
        moodDescriptionLabel.textAlignment = .left
        moodDescriptionLabel.font = UIFont(name: "Helvetica", size: 14)
        moodDescriptionLabel.textColor = .lightGray
        
        mentalDescriptionLabel.text = "Think about how you feel at this moment: Choose the best word to describe it."
        
        mentalDescriptionLabel.numberOfLines = 0
        mentalDescriptionLabel.textAlignment = .left
        mentalDescriptionLabel.font = UIFont(name: "Helvetica", size: 14)
        mentalDescriptionLabel.textColor = .lightGray
        
        reasonTextField.attributedPlaceholder = NSAttributedString(string: "Have a reason?",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        dividerView.backgroundColor = .lightGray
        
        pickersSection.backgroundColor = .pickerSection
        pickersSection.layer.cornerRadius = 10
        moodPickerView.backgroundColor = .barBackground
        mentalStatePickerView.backgroundColor = .barBackground
        
        reasonLabel.text = "Any reason to current menthal condition?"
        reasonLabel.numberOfLines = 0
        reasonLabel.textAlignment = .left
        reasonLabel.font = UIFont(name: "Helvetica", size: 16)
        reasonLabel.textColor = .lightGray
        reasonLabel.textColor = .white
        
        buttonsStack.alignment = .center
        buttonsStack.axis = .horizontal
        buttonsStack.distribution = .fill
    }
}
