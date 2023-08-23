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

final class MainViewController: UIViewController {
    @IBOutlet weak var dreamButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    private let sideMenu = SideMenuViewController()
    private let timerVM = TimerViewModel()
    let chartView = ChartView()
    lazy var menu = SideMenuNavigationController(rootViewController: sideMenu)
    private var impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu.linkDelegate = self
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        timerVM.loadSavedTimerDates {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.startTimer()
        }
        updateRemainingTime()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menu.leftSide = true
    }
    
    override func viewWillLayoutSubviews() {
        setUpConstraints()
    }
    
    //MARK: - Timer Logic
    
    func runTimer() {
        timerVM.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        timerVM.isTimerRunning = true
    }
    
    @objc func updateTimer() {
        if timerVM.seconds < 1 {
            timerVM.timer.invalidate()
            timerVM.isTimerRunning = false
            //Send alert to indicate "time's up!"
        } else {
            timerVM.seconds -= 1
            timerLabel.text = timerVM.timeString(time: TimeInterval(timerVM.seconds))
        }
    }
    
    func updateRemainingTime() {
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
    
    func startTimer() {
        timerVM.startDate = Date()
        timerVM.endDate = Calendar.current.date(byAdding: .minute, value: 30, to: timerVM.startDate!)
        
        runTimer()
    }
    
    @IBAction func dreamButtonTapped(_ sender: UIButton) {
        present(menu, animated: true, completion: nil)
        //timer triggering
        startTimer()
        timerVM.saveTimerDates()
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
