//
//  MainViewController.swift
//  Animotion
//
//  Created by Kostiantyn Kaniuka on 25.05.2023.
//

import UIKit
import Combine
import CombineCocoa
import SideMenu
import SnapKit
import FirebaseAuth
import DGCharts
import AIFlatSwitch

protocol TiggerTimerDelegate: AnyObject {
    func triggerTimer()
}

protocol ImportRadarDelegate: AnyObject {
    func importRadar()
}

final class MainViewController: UIViewController {
    @IBOutlet weak var dreamButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private let importButton = ImportGraphButton()
    private let checkMarkImage = AIFlatSwitch()
    private let sideMenu = SideMenuViewController()
    private let timerVM = TimerViewModel()
    weak var radarDelegate: ImportRadarDelegate?
    let chartView = ChartView()
    lazy var menu = SideMenuNavigationController(rootViewController: sideMenu)
    private var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private var bag = Set<AnyCancellable>()
    weak var submitDelegate: SubmitButtonDelegate? // delegate to togle submit button state(CaptureViewController)
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //        UserDefaults.standard.removeObject(forKey: "savedStartDate")
        //        UserDefaults.standard.removeObject(forKey: "savedEndDate")
        //        // Call synchronize to ensure changes are immediately saved
        //        UserDefaults.standard.synchronize()
        setUpAppearance()
        chartView.loaderDelegate = self
        sideMenu.linkDelegate = self
        saveGraphToGallary()
        checkTimerState { [weak self] in
            self?.updateRemainingTime()
        }
        
    }
    
 
    
    private func saveGraphToGallary() {
        importButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                let senseBack = UIImpactFeedbackGenerator(style: .heavy)
                self.checkMarkImage.isHidden = false
                self.checkMarkImage.setSelected(true, animated: true)
        
                self.chartView.lineChartView.backgroundColor = .darkGray
                self.chartView.lineChartView.layer.borderColor = UIColor.darkGray.cgColor
                
                self.checkMarkImage.selectionAnimationDidStart = { isSelected in
                    print("New state: \(isSelected)")
                }
                self.checkMarkImage.selectionAnimationDidStop = { isSelected in
                    self.checkMarkImage.isHidden = true
                    senseBack.impactOccurred()
                    print("State when animation stopped: \(isSelected)")
                }
                
                if let chartImage = self.chartView.lineChartView.getChartImage(transparent: true) {
                    // Save the captured image to the camera roll
                    UIImageWriteToSavedPhotosAlbum(chartImage, nil, nil, nil)
                    self.radarDelegate?.importRadar()
                    self.chartView.lineChartView.backgroundColor = .clear
                    self.chartView.lineChartView.layer.borderColor = UIColor.white.cgColor
                    let senseBack = UIImpactFeedbackGenerator(style: .heavy)
                    senseBack.impactOccurred()
                }
                
            }
        
            .store(in: &bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menu.leftSide = true
    }
    
    override func viewWillLayoutSubviews() {
        setUpConstraints()
    }
    
    //MARK: - Timer Logic
    
    private func runTimer() {
        timerVM.timer = Timer.scheduledTimer(timeInterval: 1, target: self,selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        timerVM.isTimerRunning = true
    }
    
    @objc private func updateTimer() {
        if timerVM.seconds < 1 {
            print("➡️",timerVM.seconds)
            timerVM.timer.invalidate()
            timerVM.isTimerRunning = false
            submitDelegate?.toggleState()
            //Send alert to indicate "time's up!"
        } else {
            timerVM.seconds -= 1
            timerLabel.text = timerVM.timeString(time: TimeInterval(timerVM.seconds))
        }
    }
    
    private func updateRemainingTime() {
        guard let endDate = timerVM.endDate else {
            return
        }
        
        let currentTime = Date()
        let remainingTime = Int(endDate.timeIntervalSince(currentTime))
        if remainingTime <= 0 {
            // Timer has ended, handle accordingly
            timerLabel.text = "00:00"
            timerVM.timer.invalidate()
        } else {
            timerLabel.text = timerVM.timeString(time: TimeInterval(remainingTime))
        }
    }
    
    private func startTimer() {
        timerVM.startDate = Date()
        timerVM.endDate = Calendar.current.date(byAdding: .minute, value: 1, to: timerVM.startDate!)
        runTimer()
    }
    
    private func checkTimerState(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        timerVM.loadSavedTimerDates { [weak self] isRunning in
            if isRunning == true {
                dispatchGroup.leave()
            } else {
                self?.submitDelegate?.toggleState()
            }
            
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.startTimer()
            
        }
        completion()
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
    
    private func setUpAppearance() {
        checkMarkImage.lineWidth = 2.0
        checkMarkImage.strokeColor = UIColor.white
        checkMarkImage.trailStrokeColor = UIColor.lightGray
        checkMarkImage.backgroundLayerColor = UIColor.lightGray
        checkMarkImage.animatesOnTouch = false
        checkMarkImage.isHidden = true
    }
    
    private func setUpConstraints() {
        chartView.view.addSubview(checkMarkImage)
        view.backgroundColor = UIColor(red: 178/255, green: 236/255, blue: 197/255, alpha: 1)
        view.addSubview(chartView.view)
        view.addSubview(importButton)
        chartView.view.snp.makeConstraints { make in
            if UIScreen.main.bounds.size.height >= 812 {
                make.height.equalTo(CGFloat(400))
                make.left.right.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
            } else {
                make.height.equalTo(CGFloat(350))
                make.left.right.equalToSuperview().inset(16)
                make.centerY.equalToSuperview().offset(32)
            }
            if UIScreen.main.bounds.size.height < 812 {
                backgroundImage.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.top.bottom.equalToSuperview()
                    make.left.right.equalToSuperview().inset(-8)
                }
            }
        }
        checkMarkImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        
        importButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(chartView.view.snp.bottom).offset(50)
        }
    }
}

extension MainViewController: TiggerTimerDelegate {
    func triggerTimer() {
        startTimer()
        timerVM.saveTimerDates { [weak self] in
            self?.updateRemainingTime()
        }
    }
}

extension MainViewController: ChartLoaderDelegate {
    func finishLoading() {
        loadingIndicator.stopAnimating()
    }
}
