//
//  DetailViewController.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit

class DetailViewController: UIViewController {

	private let muscleName: String
	
	init(name: String) {
		self.muscleName = name
		
		super.init(nibName: "DetailViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		configureUI()
    }
	
	private func configureUI() {
		self.navigationItem.title = muscleName
	}
}
