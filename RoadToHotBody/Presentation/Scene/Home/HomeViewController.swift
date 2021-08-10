//
//  HomeViewController.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit

protocol HomeVCCoordinatorDelegate: class {
	func buttonClicked(name: String)
}

class HomeViewController: UIViewController {
	
	@IBAction func AButtonClicked(_ sender: Any) {
		self.coordinatorDelegate?.buttonClicked(name: muscleList[0])
	}
	
	@IBAction func BButtonClicked(_ sender: Any) {
		self.coordinatorDelegate?.buttonClicked(name: muscleList[1])
	}

	var coordinatorDelegate: HomeVCCoordinatorDelegate?

	private let muscleList = ["A", "B"]
	
	init() {
		super.init(nibName: "HomeViewController", bundle: nil)
		
		self.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 1)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureUI()
    }
	
	private func configureUI() {
		self.navigationItem.title = "title"
	}
}
