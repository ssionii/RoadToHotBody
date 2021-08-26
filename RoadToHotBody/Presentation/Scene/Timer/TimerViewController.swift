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
	@IBOutlet weak var playingButton: UIButton!
	
	private var timeObservable: Disposable?
	
	init() {
		super.init(nibName: "TimerViewController", bundle: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		
    }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
