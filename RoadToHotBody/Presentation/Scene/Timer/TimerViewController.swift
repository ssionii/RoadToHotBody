//
//  TimerViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/26.
//

import UIKit
import RxSwift
import RxCocoa

protocol TimerVCCoordinatorDelegate: AnyObject {
    func saveTimeRecord()
}

class TimerViewController: UIViewController {

	@IBOutlet weak var timerLabel: UILabel!
    
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	
	@IBAction func playButtonClicked(_ sender: Any) {
		self.isPlaying.onNext(true)
	}
	@IBAction func stopButtonClicked(_ sender: Any) {
		self.isPlaying.onNext(false)
		
		let alert = UIAlertController(title: "시간 기록 하시겠습니까?", message: "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "네", style: .default, handler: { [weak self ] _ in
			guard let self = self else { return }
			self.saveTimeRecord.onNext(())
		}))
		alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
		
		present(alert, animated: false, completion: nil)
	}
	
	private let viewModel: TimerViewModel
	private let disposeBag = DisposeBag()
    weak var coordiantorDelegate: TimerVCCoordinatorDelegate?
	
	private var isPlaying = PublishSubject<Bool>()
	private var saveTimeRecord = PublishSubject<Void>()
    private var tempTime = 0
    private var stoppedTime = 0
	
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
        let output = viewModel.transform(
            input: TimerViewModel.Input(
                isPlaying: self.isPlaying.asObservable(),
                saveTimeRecord: self.saveTimeRecord.asObservable()
            )
        )

        output.timeString
            .withUnretained(self)
            .subscribe(onNext: { owner, time in
                owner.timerLabel.text = time
            })
            .disposed(by: disposeBag)
        
        output.savedTimeRecord
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordiantorDelegate?.saveTimeRecord()
            })
            .disposed(by: disposeBag)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
