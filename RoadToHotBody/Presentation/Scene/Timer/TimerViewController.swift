//
//  TimerViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/26.
//

import UIKit
import RxSwift
import RxCocoa

class TimerViewController: UIViewController {

	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	
	@IBAction func playButtonClicked(_ sender: Any) {
		self.isPlaying.onNext(true)
	}
	@IBAction func stopButtonClicked(_ sender: Any) {
		self.isPlaying.onNext(false)
	}
	
	private let viewModel: TimerViewModel
	private let disposeBag = DisposeBag()
	
	private var isPlaying = PublishSubject<Bool>()
	
	init(viewModel: TimerViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "TimerViewController", bundle: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureUI()
		bind()
    }
	
	private func configureUI() {
		
		timerLabel.font = .monospacedSystemFont(ofSize: 70, weight: .ultraLight)
		
		playButton.layer.cornerRadius = playButton.frame.height / 2
		playButton.layer.borderWidth = 1
		playButton.layer.borderColor = UIColor.init(named: "mainColor")?.cgColor
		
		stopButton.layer.cornerRadius = playButton.frame.height / 2
		stopButton.layer.borderWidth = 1
		stopButton.layer.borderColor = UIColor.red.cgColor
	}
	
	private func bind() {
		let output = viewModel.transform(input: TimerViewModel.Input(isPlaying: self.isPlaying.asObservable()))
		
		output.timeString
			.drive(timerLabel.rx.text)
			.disposed(by: disposeBag)
		
		isPlaying
			.withUnretained(self)
			.subscribe(onNext: { owner, isPlaying in
				owner.stopButton.isHidden = !isPlaying
				owner.playButton.isHidden = isPlaying
			})
			.disposed(by: disposeBag)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
