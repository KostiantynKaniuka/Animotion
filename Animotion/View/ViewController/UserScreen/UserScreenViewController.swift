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

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

final class UserScreenViewController: UIViewController, ChartViewDelegate {
    private let backgroundImage =       UIImageView()
    private let privacyPolicy =         UILabel()
    private let chartView =             RadarChartView()
    private let userNameField =         UITextView()
    private var userImage =             UIImageView()
    private let logOutButton =          LogoutButton()
    private let editButton =            EditAccountButton()
    private let deleteAccountButton =   DeleteAccountButton()
    private let buttonsStack =          UIStackView()
    
    private let userScreenVM =          UserScreenViewModel()
    
    private let menthalState = ["Happy","Good","Anxious","Sad","Angry","Satisfied"]
    private var radarData = [String: Double]()
    
    private var alertMessage: AlertMessage = .error
    weak var logoutDelegate: LogoutDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        chartView.delegate = self
        setRadarData()
        setUpRadar()
        chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAppearance()
        setupConstaints()
        deleteButtonTapped()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    private func setRadarData() {
        radarData = userScreenVM.menthalCount
     
        let radarEntries = [RadarChartDataEntry(value: radarData["Happy"] ?? 0),
                            RadarChartDataEntry(value: radarData["Good"] ?? 0),
                            RadarChartDataEntry(value: radarData["Anxious"] ?? 0),
                            RadarChartDataEntry(value: radarData["Sad"] ?? 0),
                            RadarChartDataEntry(value: radarData["Angry"] ?? 0),
                            RadarChartDataEntry(value: radarData["Satisfied"] ?? 0)
         ]
        
        let set1 = RadarChartDataSet(entries: radarEntries, label: "Menthal State")
        set1.setColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1))
        set1.fillColor = userScreenVM.setChartColor(data: radarData)
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.7
        set1.lineWidth = 1
        set1.drawHighlightCircleEnabled = true
        set1.setDrawHighlightIndicators(false)
        
     
        
        let data: RadarChartData = [set1]
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.white)
        
        chartView.data = data
    }
    
    private func deleteButtonTapped() {
        let user = Auth.auth().currentUser
        deleteAccountButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.alertMessage = .delete
                self.userScreenVM.showAlert(title: self.alertMessage.title,
                                            message: self.alertMessage.body,
                                            vc: self,
                                            handler: ({ _ in
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
                }), cancelhadler: UIAlertAction())
            }
            .store(in: &userScreenVM.bag)
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

//MARK: - layout
extension UserScreenViewController {
    
    private func setupConstaints() {
        view.add(subviews: backgroundImage,
                 userImage,
                 userNameField,
                 chartView,
                 buttonsStack,
                 editButton,
                 privacyPolicy
        )
        

        buttonsStack.addArrangedSubview(logOutButton)
        buttonsStack.addArrangedSubview(deleteAccountButton)
        
        backgroundImage.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }

        chartView.snp.makeConstraints { make in
            make.top.equalTo(userNameField.snp.bottom).offset(35)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(300)
        }

        userImage.snp.makeConstraints { make in
            make.top.equalTo(view).offset(60)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize(width: 80, height: 80))
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

        buttonsStack.snp.makeConstraints { make in
            make.centerX.equalTo(chartView)
            make.top.equalTo(chartView.snp.bottom).offset(60)
        }

        editButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 40))
            make.top.equalTo(buttonsStack.snp.bottom).offset(8)
            make.centerX.equalTo(chartView)
        }

        privacyPolicy.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(16)
            make.centerX.equalTo(buttonsStack)
        }
    }
    
    private func setUpRadar() {
        chartView.chartDescription.enabled = false
        let scaleFactor: CGFloat = 1.2 // Adjust this value to increase the size
           chartView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        chartView.webLineWidth = 1
        chartView.innerWebLineWidth = 1
        chartView.webColor = .lightGray
        chartView.innerWebColor = .lightGray
        chartView.webAlpha = 1
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .white
        
        let yAxis = chartView.yAxis
        yAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        yAxis.labelCount = 6
        yAxis.axisMinimum = 0
        let data = userScreenVM.menthalCount.values.max()
        yAxis.axisMaximum = data ?? 1
        yAxis.drawLabelsEnabled = false
    }
    
    private func setupAppearance() {
        privacyPolicy.text =                "Privacy policy"
        privacyPolicy.textColor =           .darkGray
        privacyPolicy.font =                .systemFont(ofSize: 12)
        
        buttonsStack.spacing =              5
        buttonsStack.alignment =            .fill
        buttonsStack.axis =                 .horizontal
        buttonsStack.distribution =         .fill
        
     
        chartView.contentMode =             .scaleAspectFill
        chartView.backgroundColor =         .clear
        
        userImage.image =                   UIImage(named: "back 1")
        userImage.frame.size =              CGSize(width: 80, height: 80)
        userImage.layer.borderWidth =       1
        userImage.layer.borderColor =       UIColor.white.cgColor
        userImage.layer.cornerRadius =      userImage.frame.size.width / 2
        userImage.layer.masksToBounds =     false
        userImage.clipsToBounds =           true
        
        userNameField.text =                "User name"
        userNameField.font =                .systemFont(ofSize: 17)
        userNameField.textAlignment =       .center
        userNameField.textColor =           .white
        userNameField.textContainer
            .maximumNumberOfLines =         1
        userNameField.isEditable =          true
        userNameField.backgroundColor =     .clear
        backgroundImage.image =             UIImage(named: "backtest")
    }
}
