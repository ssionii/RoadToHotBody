//
//  RecordViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit

protocol RecordVCCoordinatorDelegate: AnyObject {
	func timerClicked()
	func photoClicked()
	func allRecordClicked()
}

class RecordViewController: UIViewController {
	
	@IBOutlet weak var timerView: UIView!
	@IBOutlet weak var photoView: UIView!
	
	private let viewModel: RecordViewModel
	var coordinatorDelegate: RecordVCCoordinatorDelegate?
	
	init(viewModel: RecordViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "RecordViewController", bundle: nil)
		
		self.tabBarItem = UITabBarItem(title: "기록", image: UIImage(systemName: "person"), tag: 3)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureUI()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		guard let topItem = self.navigationController?.navigationBar.topItem else {
			return
		}
		
		topItem.title = "너의 기록"
	}
	
	private func configureUI() {
		self.timerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.timerClicked)))
		self.photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.photoClicked)))
	}
	
	@objc func photoClicked(sender : UITapGestureRecognizer) {
		self.coordinatorDelegate?.photoClicked()
	}
	
	@objc func timerClicked(sender : UITapGestureRecognizer) {
		self.coordinatorDelegate?.timerClicked()
	}
}
