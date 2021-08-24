//
//  RecordViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/24.
//

import UIKit

class RecordViewController: UIViewController {

	private let viewModel: RecordViewModel
	
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
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		guard let topItem = self.navigationController?.navigationBar.topItem else {
			return
		}
		topItem.title = "너의 기록"
	}
}
