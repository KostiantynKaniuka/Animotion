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

protocol TiggerTimerDelegate: AnyObject {
    func triggerTimer()
}

final class MainViewController: UIViewController {
    @IBOutlet weak var dreamButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    private let sideMenu = SideMenuViewController()
    private let timerVM = TimerViewModel()
    let chartView = ChartView()
    lazy var menu = SideMenuNavigationController(rootViewController: sideMenu)
    private var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    weak var submitDelegate: SubmitButtonDelegate? // delegate to togle submit button state(CaptureViewController)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu.linkDelegate = self
        checkTimerState { [weak self] in
            self?.updateRemainingTime()
        }
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
    
    private func setUpConstraints() {
        view.backgroundColor = UIColor(red: 178/255, green: 236/255, blue: 197/255, alpha: 1)
        view.addSubview(chartView.view)
        chartView.view.snp.makeConstraints { make in
            make.height.equalTo(CGFloat(400))
            make.left.right.equalToSuperview().inset(16)
            make.center.equalToSuperview()
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
