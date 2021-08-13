//
//  HomeViewController.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeVCCoordinatorDelegate: class {
	func buttonClicked(muscle: Muscle)
}

class HomeViewController: UIViewController {
	
	@IBAction func AButtonClicked(_ sender: Any) {
		self.coordinatorDelegate?.buttonClicked(muscle: muscleList[0])
	}
	
	@IBAction func BButtonClicked(_ sender: Any) {
		self.coordinatorDelegate?.buttonClicked(muscle: muscleList[1])
	}

	private let viewModel: HomeViewModel
	var coordinatorDelegate: HomeVCCoordinatorDelegate?
	
	private let disposeBag = DisposeBag()

	private let muscleList = [
		Muscle(index: 0, name: "승모근", direction: .Front),
		Muscle(index: 1, name: "대퇴근", direction: .Both),
	]
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "HomeViewController", bundle: nil)
		
		self.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 1)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureUI()
		bind()
    }
	
	private func configureUI() {
		self.navigationItem.title = "title"
	}
	
	private func bind() {
		let output = viewModel.transform(input: HomeViewModel.Input())
		
		output.muscles
			.subscribe(onNext: { item in
				
				print(item)
			})
			.disposed(by: disposeBag)
	}
}
