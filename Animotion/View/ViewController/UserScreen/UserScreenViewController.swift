//
//  UserScreenViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 10.07.2023.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import DGCharts
import FirebaseAuth
import PhotosUI

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

protocol SideMenuPhotoDelegate: AnyObject {
    func sendPhoto()
}

final class UserScreenViewController: UIViewController, ChartViewDelegate {
    //MARK: - UI Outlets
    private let backgroundImage = UIImageView()
    private let chartView = RadarChartView()
    private let userNameField = UITextView()
    private var userImage = UIImageView()
    private let logOutButton = LogoutButton()
    private let editButton = EditAccountButton()
    private let deleteAccountButton = DeleteAccountButton()
    private let buttonsStack = UIStackView()
    private let plusButton = UIButton()
    private let loadingIndicator = UIActivityIndicatorView()
    private let imageLoadingIndicator = UIActivityIndicatorView()
    //MARK: - Properties
    private let userScreenVM = UserScreenViewModel()
    private let imageManager = ImageManager()
    
    private let menthalState = ["Happy","Good","Anxious","Sad","Angry","Satisfied"]
    private var radarData = [String: Int]()
    private var radarEntries = [RadarChartDataEntry]()
    
    private var alertMessage: AlertMessage = .error
    weak var logoutDelegate: LogoutDelegate?
    weak var sideMenuPhotoDelegate: SideMenuPhotoDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        plusButton.isHidden = true
        userNameField.isEditable = false
        chartView.delegate = self
        userNameField.delegate = self
        bindTextField()
        applyUserInfo()
        setRadarData()
        chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
        editButtonPressed()
        plussButtonTapped()
        deleteButtonTapped()
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        chartView.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupAppearance()
        setupConstaints()
        setProfileImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Methods
    
    private func applyUserInfo() {
        userScreenVM.parseUser { [weak self] in
            DispatchQueue.main.async {
                self?.userNameField.text = self?.userScreenVM.username.value
            }
        }
    }
    
    private func bindTextField () {
        userNameField.textPublisher
            .sink { [weak self] text in
                guard let self = self else { return }
                self.userScreenVM.username.value = text ?? "user name"
            }
            .store(in: &userScreenVM.bag)
    }
    
    private func plussButtonTapped() {
        plusButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.pickImage()
            }
            .store(in: &userScreenVM.bag)
    }
    
    private func editButtonPressed() {
        editButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.plusButton.isHidden = false
                self.userNameField.isEditable = true
                self.userNameField.becomeFirstResponder()
            }
            .store(in: &userScreenVM.bag)
    }
    
    
    
    private func setRadarData() {
        loadingIndicator.startAnimating()
        radarData = [:]
        radarEntries = []
        guard let id = Auth.auth().currentUser?.uid else {return}
        userScreenVM.parseRadar(id: id) { [weak self] data in
            guard let self = self else {return}
            self.radarData = data
            
            self.radarEntries = [
                RadarChartDataEntry(value: Double(self.radarData["Happy"] ?? 0)),
                RadarChartDataEntry(value: Double(self.radarData["Good"] ?? 0)),
                RadarChartDataEntry(value: Double(self.radarData["Anxious"] ?? 0)),
                RadarChartDataEntry(value: Double(self.radarData["Sad"] ?? 0)),
                RadarChartDataEntry(value: Double(self.radarData["Angry"] ?? 0)),
                RadarChartDataEntry(value: Double(self.radarData["Satisfied"] ?? 0))
            ]
            
            if (data.reduce(0){ $0 + $1.value } == 0) {
                self.loadingIndicator.stopAnimating()
                return
            } // radar data bug 🤯
            
            let set1 = RadarChartDataSet(entries: self.radarEntries, label: "Mental State")
            set1.setColor(self.userScreenVM.setChartColor(data: self.radarData))
            set1.fillColor = self.userScreenVM.setChartColor(data: self.radarData)
            set1.drawFilledEnabled = true
            set1.fillAlpha = 0.7
            set1.lineWidth = 1
            set1.drawHighlightCircleEnabled = true
            set1.setDrawHighlightIndicators(false)
            let data: RadarChartData = [set1]
            data.setValueFont(.systemFont(ofSize: 8, weight: .light))
            data.setDrawValues(false)
            data.setValueTextColor(.white)
            self.chartView.data = data
            let yAxis = self.chartView.yAxis
            let maxValue = self.radarData.values.max()
            yAxis.axisMaximum = Double(maxValue ?? 0) + 0.5
            self.loadingIndicator.stopAnimating()
        }
        setUpRadar()
    }
    
    private func deleteButtonTapped() {
        let user = Auth.auth().currentUser
        guard let userId = user?.uid else {return}
        deleteAccountButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.alertMessage = .delete
                self.userScreenVM.showAlert(title: self.alertMessage.title,
                                            message: self.alertMessage.body,
                                            vc: self,
                                            handler: ({ _ in
                    FireAPIManager.shared.deleteAccountData(id: userId) {
                        user?.delete { error in
                            if let error = error as NSError? {
                                let message = self.userScreenVM.formateAuthError(error)
                                self.userScreenVM.showAlert(title: self.alertMessage.title,
                                                            message: message,
                                                            vc: self)
                            } else {
                                self.logoutDelegate?.didLogout()
                                print("😶‍🌫️ account deleted")
                            }
                        }
                    }
                }), cancelhadler: UIAlertAction())
            }
            .store(in: &userScreenVM.bag)
    }
    
    @objc override func dismissKeyboard() {
        plusButton.isHidden = true
        view.endEditing(true)
    }
    
    @objc private func logOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            logoutDelegate?.didLogout()
        } catch {
            print("Unexpected error occurred while signing out: \(error)")
        }
    }
    
    deinit {
        print("➡️ user screen gone")
    }
}


extension UserScreenViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return menthalState[Int(value) % menthalState.count]
    }
}

//MARK: - RADAR REFETCH
extension UserScreenViewController: RadarDataDelegate {
    func refetchRadarData() {
        DispatchQueue.main.async { [weak self] in
            self?.setRadarData()
        }
    }
}

extension UserScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        userImage.image = selectedImage
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius =      userImage.frame.size.width / 2
        let imageManager = ImageManager()
        imageManager.saveImageToApp(image: selectedImage)
        plusButton.isHidden = true
        sideMenuPhotoDelegate?.sendPhoto()
        self.dismiss(animated: true)
    }
}

extension UserScreenViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            userScreenVM.updateUserName { [weak self] in
                textView.resignFirstResponder()
                self?.plusButton.isHidden = true
            }
            return false
        } else {
            return true
        }
    }
}

extension UserScreenViewController: ImportRadarDelegate {
    func importRadar() {
        chartView.backgroundColor = .darkGray
        if let chartImage = self.chartView.getChartImage(transparent: true) {
            UIImageWriteToSavedPhotosAlbum(chartImage, nil, nil, nil)
        }
        chartView.backgroundColor = .clear
    }
}

//MARK: - layout
extension UserScreenViewController {
    
    private func setupConstaints() {
        view.add(subviews: backgroundImage,
                 imageLoadingIndicator,
                 loadingIndicator,
                 userImage,
                 plusButton,
                 userNameField,
                 chartView,
                 buttonsStack,
                 editButton
        )
        
        buttonsStack.addArrangedSubview(logOutButton)
        buttonsStack.addArrangedSubview(deleteAccountButton)
        
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
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageLoadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userNameField.snp.bottom).offset(16)
        }
        
        chartView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(view)
            make.right.equalTo(view)
            if UIScreen.main.bounds.size.height < 812{
                make.height.equalTo(250)
            } else {
                make.height.equalTo(350)
            }
        }
        
        if UIScreen.main.bounds.size.height < 812 {
            userImage.snp.makeConstraints { make in
                make.top.equalTo(view).offset(40)
                make.centerX.equalTo(view.snp.centerX)
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
            
            plusButton.snp.makeConstraints { make in
                make.top.equalTo(view).offset(40)
                make.centerX.equalTo(view.snp.centerX).offset(userImage.frame.width - 8)
                make.size.equalTo(CGSize(width: 70, height: 70))
            }
            
        } else {
            userImage.snp.makeConstraints { make in
                make.top.equalTo(view).offset(80)
                make.centerX.equalTo(view.snp.centerX)
                make.size.equalTo(CGSize(width: 100, height: 100))
            }
            
            plusButton.snp.makeConstraints { make in
                make.top.equalTo(view).offset(80)
                make.centerX.equalTo(view.snp.centerX).offset(userImage.frame.width - 8)
                make.size.equalTo(CGSize(width: 100, height: 100))
            }
        }
        
        userNameField.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(8)
            make.centerX.equalTo(userImage.snp.centerX)
            make.size.equalTo(CGSize(width: 350, height: 40))
        }
        
        logOutButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        if UIScreen.main.bounds.size.height < 812 {
            buttonsStack.snp.makeConstraints { make in
                make.centerX.equalTo(chartView)
                make.bottom.equalTo(view.safeAreaInsets.bottom).offset(-100)
            }
            
        } else {
            buttonsStack.snp.makeConstraints { make in
                make.centerX.equalTo(chartView)
                make.bottom.equalTo(view.safeAreaInsets.bottom).offset(-150)
            }
        }
        
        editButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.top.equalTo(buttonsStack.snp.bottom).offset(8)
            make.centerX.equalTo(chartView)
        }
    }
    
    private func setUpRadar() {
        chartView.chartDescription.enabled =    false
        chartView.webLineWidth =                1
        chartView.innerWebLineWidth =           1
        chartView.webColor =                    .lightGray
        chartView.innerWebColor =               .lightGray
        chartView.webAlpha =                    1
        
        let xAxis =                             chartView.xAxis
        xAxis.labelFont =                       .systemFont(ofSize: 12, weight: .light)
        xAxis.xOffset =                         0
        xAxis.yOffset =                         0
        xAxis.axisMinimum =                     0
        xAxis.valueFormatter =                  self
        xAxis.labelTextColor =                  .white
        
        let yAxis =                             chartView.yAxis
        yAxis.labelFont =                       .systemFont(ofSize: 12, weight: .light)
        yAxis.labelCount =                      6
        yAxis.axisMinimum =                     0
        yAxis.drawLabelsEnabled =               false
    }
    
    private func setupAppearance() {
        imageLoadingIndicator.style =           .large
        imageLoadingIndicator.frame.size =      CGSize(width: 100, height: 80)
        imageLoadingIndicator.color =           .white
        imageLoadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.style =                .large
        loadingIndicator.frame.size =           CGSize(width: 100, height: 80)
        loadingIndicator.color =                .white
        loadingIndicator.hidesWhenStopped =     true
        
        buttonsStack.spacing =                   5
        buttonsStack.alignment =                .fill
        buttonsStack.axis =                     .horizontal
        buttonsStack.distribution =             .fill
        
        chartView.contentMode =                 .scaleAspectFill
        chartView.backgroundColor =             .clear
        
        if UIScreen.main.bounds.size.height < 812 {
            userImage.frame.size =              CGSize(width: 70, height: 70)
        } else {
            userImage.frame.size =              CGSize(width: 100, height: 100)
        }
        userImage.layer.borderWidth =               1
        userImage.layer.masksToBounds =             false
        userImage.clipsToBounds =                   true
        userImage.isUserInteractionEnabled =        true
        userImage.tintColor =                       .white
        
        userNameField.text =                        userScreenVM.username.value
        userNameField.font =                        .systemFont(ofSize: 17)
        userNameField.textAlignment =               .center
        userNameField.textColor =                   .white
        userNameField.textContainer
            .maximumNumberOfLines =                  1
        userNameField.backgroundColor =             .clear
        userNameField.returnKeyType =               .done
        backgroundImage.image =                     UIImage(named: "backtest")
        userNameField.autocorrectionType =          .no
        userNameField.spellCheckingType =           .no
        userNameField.smartQuotesType =             .no
        
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.contentHorizontalAlignment =     .center
        plusButton.contentVerticalAlignment =       .center
        let scaleFactor: CGFloat =                  2.0 // Adjust this value to increase the size
        plusButton.transform =                      CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        plusButton.tintColor =                      .white
    }
}

extension UserScreenViewController {
    
    private func setProfileImage() {
        let imageManager = ImageManager()
        
        guard let image = imageManager.loadImageFromApp() else {
            userImage.image = UIImage(systemName: "person.circle")
            userImage.layer.borderColor = UIColor.appBackground.cgColor
            return
        }
        userImage.image = image
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
    }
    
    //MARK: - IMAGE PICKER
    private func pickImage() {
        imageLoadingIndicator.startAnimating()
        
        let photos = PHPhotoLibrary.authorizationStatus()
        switch photos {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                switch status {
                case .notDetermined:
                    return
                case .restricted:
                    return
                case .denied:
                    return
                case .authorized:
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {return}
                        let imagePicker = UIImagePickerController()
                        imagePicker.sourceType = .photoLibrary
                        imagePicker.allowsEditing = true
                        imagePicker.delegate = self
                        self.imageLoadingIndicator.stopAnimating()
                        self.present(imagePicker, animated: true)
                    }
                case .limited:
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {return}
                        let imagePicker = UIImagePickerController()
                        imagePicker.sourceType = .photoLibrary
                        imagePicker.allowsEditing = true
                        imagePicker.delegate = self
                        
                        self.imageLoadingIndicator.stopAnimating()
                        self.present(imagePicker, animated: true)
                    }
                @unknown default:
                    return
                }
            })
        case .restricted:
            return
        case .denied:
            return
        case .authorized:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                
                self.imageLoadingIndicator.stopAnimating()
                self.present(imagePicker, animated: true)
            }
        case .limited:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                
                self.imageLoadingIndicator.stopAnimating()
                self.present(imagePicker, animated: true)
            }
        @unknown default:
            return
        }
    }
}
