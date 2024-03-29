//
//  MoodCaptureViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.08.2023.
//

import UIKit
import SnapKit
import FirebaseAuth
import Combine
import CombineCocoa

protocol GraphDataDelegate: AnyObject {
    func refetchGraphData()
}

protocol RadarDataDelegate: AnyObject {
    func refetchRadarData()
}

protocol SubmitButtonDelegate: AnyObject {
    func toggleState()
}

final class CaptureViewController: UIViewController {
    //MARK: - UI Outlets
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
    private let privacyPolicyTextView =         UITextView()
    private let reasonTextField = CustomTextField()
    private let submitButton = SubmitButton()
    private let cancelButton = CancelCaptureButton()
    //MARK: - Properties
    private var captureVM = CaptureMoodViewModel()
    private var isViewShiftedUp = false
    private var alertMessage: AlertMessage = .submit
    
    weak var remainingTimeDelegate: TimerValueDelegate?
    weak var graphDelegate: GraphDataDelegate?
    weak var radarDelegate: RadarDataDelegate?
    weak var timerDelegate: TiggerTimerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Capture mood here"
        
        mentalStatePickerView.dataSource = self
        mentalStatePickerView.delegate = self
        moodPickerView.delegate = self
        moodPickerView.dataSource = self
        reasonTextField.delegate = self
        parseUserRadar()
        setUpLayout()
        applyUISettings()
        insertTheLink()
        submitButtonTapped()
        cancelButtonTapped()
        textFieldPublisher()
        dealingWithKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Methods
    private func insertTheLink() {
        let color = UIColor.darkGray
        let linkColor = color
        let attributedPrivacy = NSMutableAttributedString(string: "Privacy policy")
        let privatelinkRange = NSRange(location: 0, length: 14)
        let privatelinkColor = color
        attributedPrivacy.addAttribute(.link, value: "https://docs.google.com/document/d/1bJsy3UPdnzq5McYI2BePdUM8hYxh9LRwhfrbxV9uOjY/edit?usp=sharing", range: privatelinkRange)
        attributedPrivacy.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privatelinkRange)
        attributedPrivacy.addAttribute(.underlineColor, value: linkColor, range: privatelinkRange)
        privacyPolicyTextView.linkTextAttributes = [.foregroundColor: privatelinkColor]
        privacyPolicyTextView.attributedText = attributedPrivacy
    }
    
    private func parseUserRadar() {
        guard let id = Auth.auth().currentUser?.uid else {return}
        captureVM.parseRadar(id: id) { [weak self] data in
            self?.captureVM.menthaldata = data
        }
    }
    
    private func textFieldPublisher() {
        reasonTextField.textPublisher
            .sink { [weak self] text in
                self?.captureVM.reasonText.value = text ?? ""
            }
            .store(in: &captureVM.bag)
    }
    
    private func submitButtonTapped() {
        submitButton.tapPublisher
            .sink { [weak self] in
                guard let self = self else {return}
                if self.captureVM.buttonEnabled.value == true {
                    guard let user = Auth.auth().currentUser else {return}
                    let id = user.uid
                    let senseBack = UIImpactFeedbackGenerator(style: .heavy)
                    
                    self.captureVM.sendUserChoice(id: id) { graph, radar in
                        FireAPIManager.shared.updateUserChartsData(id: id,
                                                                   reason: self.captureVM.reasonText.value,
                                                                   graphData: graph,
                                                                   radarData: radar) {
                            
                            self.captureVM.buttonEnabled.value = false
                            self.timerDelegate?.triggerTimer()
                            self.graphDelegate?.refetchGraphData()
                            self.radarDelegate?.refetchRadarData()
                            self.reasonTextField.text = nil
                            self.view.endEditing(true)
                        }
                        
                        senseBack.impactOccurred()
                        self.alertMessage = .submit
                        self.captureVM.showAlert(title: self.alertMessage.title,
                                                 message: self.alertMessage.body,
                                                 vc: self)
                    }
                } else {
                    self.alertMessage = .timer
                    let remainigTime = remainingTimeDelegate?.timerValue
                    self.captureVM.showAlert(title: alertMessage.title,
                                             message: "\(alertMessage.body) \(remainigTime ?? "")",
                                             vc: self)
                    self.reasonTextField.text = nil
                    self.view.endEditing(true)
                }
            }
            .store(in: &captureVM.bag)
    }
    
    private func cancelButtonTapped() {
        cancelButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.reasonTextField.text = nil
                self.moodPickerView.selectRow(0, inComponent: 0, animated: true)
                self.mentalStatePickerView.selectRow(0, inComponent: 0, animated: true)
                self.view.endEditing(true)
            }
            .store(in: &captureVM.bag)
    }
    
    @objc override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

extension CaptureViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var result = 0
        if pickerView == moodPickerView {
            result = CaptureMoodViewModel.moodPickerData.count
        }
        if pickerView == mentalStatePickerView {
            result = CaptureMoodViewModel.menthalStatePickerData.count
        }
        
        return result
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title: NSAttributedString = NSAttributedString(string: "")
        if pickerView == moodPickerView {
            title = NSAttributedString(string: String(CaptureMoodViewModel.moodPickerData[row]),
                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
        
        if pickerView == mentalStatePickerView {
            title = NSAttributedString(string: CaptureMoodViewModel.menthalStatePickerData[row],
                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            captureVM.userMenthalString = title.string
        }
        return title
    }
}

//MARK: - Picker delegate

extension CaptureViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == moodPickerView {
            captureVM.moodData = CaptureMoodViewModel.moodPickerData[row]
        }
        if pickerView == mentalStatePickerView {
            captureVM.pickerChoice = CaptureMoodViewModel.menthalStatePickerData[row]
        }
        print(captureVM.moodData)
        print(captureVM.pickerChoice)
    }
    
}

//MARK: - TextFieldDelegate

extension CaptureViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let text = textField.text ?? ""
        let updatedText = (text as NSString).replacingCharacters(in: range,
                                                                 with: string)
        
        if updatedText.count > 30 {
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CaptureViewController: SubmitButtonDelegate {

    func toggleState() {
        captureVM.buttonEnabled.value = true
    }
}

//MARK: - Keybord Apperiance
extension CaptureViewController {
    
    private func shiftViewUp() {
        if !isViewShiftedUp {
            reasonTextField.snp.updateConstraints { make in
                if UIScreen.main.bounds.size.height >= 812 { // iPhone X and newer models
                    reasonLabel.isHidden = true
                    make.top.equalTo(reasonLabel.snp.bottom).offset(-80)
                } else { // iPhone 8 and older models
                    make.top.equalTo(reasonLabel.snp.bottom).offset(-100)
                }
                isViewShiftedUp = true
            }
        }
    }
    
    private func resetViewPosition() {
        if isViewShiftedUp {
            
            reasonTextField.snp.updateConstraints { make in
                
                reasonLabel.isHidden = false
                make.top.equalTo(reasonLabel.snp.bottom)
                isViewShiftedUp = false
            }
        }
    }
    
    private func dealingWithKeyboard() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in
                guard let self = self else {return}
                
                if self.isViewShiftedUp == false {
                    self.shiftViewUp()
                }
            }
            .store(in: &captureVM.bag)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                guard let self = self else {return}
                
                self.resetViewPosition()
                self.view.layoutIfNeeded()
            }
            .store(in: &captureVM.bag)
    }
    
}

//MARK: - Layout
extension CaptureViewController {
    
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
                        buttonsStack,
                        privacyPolicyTextView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.scrollView)
            make.left.right.equalTo(self.view)
            make.width.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
        }
        
        if UIScreen.main.bounds.size.height < 812 {
            backgroundImage.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(-8)
            }
        } else {
            backgroundImage.snp.makeConstraints { make in
                make.top.bottom.right.left.equalToSuperview()
            }
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
        
        privacyPolicyTextView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 30))
            make.centerX.equalToSuperview()
            
            if UIScreen.main.bounds.size.height < 812 {
                make.bottom.equalToSuperview().inset(20)
                
            } else {
                make.bottom.equalToSuperview().inset(50)
            }
        }
    }
    
    private func applyUISettings() {
        backgroundImage.image =                     UIImage(named: "backtest")
        moodPickerView.layer.cornerRadius =         10
        mentalStatePickerView.layer.cornerRadius =  10
        
        privacyPolicyTextView.text =               "Privacy policy"
        privacyPolicyTextView.textColor =          .darkGray
        privacyPolicyTextView.font =               .systemFont(ofSize: 12)
        privacyPolicyTextView.backgroundColor =    .clear
        privacyPolicyTextView.isEditable =         false
        privacyPolicyTextView.textAlignment =      .center
        
        moodDescriptionLabel.text =                "Please rate your mood from 1 to 10 where: \n1 - Horrible, \n10 - Wonderful."
        moodDescriptionLabel.numberOfLines =        0
        moodDescriptionLabel.textAlignment =        .left
        moodDescriptionLabel.font =                 UIFont(name: "Helvetica", size: 14)
        moodDescriptionLabel.textColor =            .lightGray
        
        mentalDescriptionLabel.text =               "Think about how you feel at this moment: Choose the best word to describe it."
        
        mentalDescriptionLabel.numberOfLines =      0
        mentalDescriptionLabel.textAlignment =      .left
        mentalDescriptionLabel.font =               UIFont(name: "Helvetica", size: 14)
        mentalDescriptionLabel.textColor =          .lightGray
        
        reasonTextField.attributedPlaceholder =     NSAttributedString(string: "Have a reason?",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        dividerView.backgroundColor =               .lightGray
        pickersSection.backgroundColor =            .pickerSection
        pickersSection.layer.cornerRadius =         10
        moodPickerView.backgroundColor =            .barBackground
        mentalStatePickerView.backgroundColor =     .barBackground
        
        reasonLabel.text =                          "Any reason to current menthal condition?"
        reasonLabel.numberOfLines =                 0
        reasonLabel.textAlignment =                 .left
        reasonLabel.font =                          UIFont(name: "Helvetica", size: 16)
        reasonLabel.textColor =                     .lightGray
        reasonLabel.textColor =                     .white
        
        buttonsStack.alignment =                    .center
        buttonsStack.axis =                         .horizontal
        buttonsStack.distribution =                 .fill
    }
}
