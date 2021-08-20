//
//  HomeViewController.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit
import RxSwift
import RxCocoa
import JJFloatingActionButton

protocol HomeVCCoordinatorDelegate: AnyObject {
	func buttonClicked(muscle: Muscle)
}

class HomeViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var directionButton: UIButton!
	
	private let viewModel: HomeViewModel
	var coordinatorDelegate: HomeVCCoordinatorDelegate?
	private let disposeBag = DisposeBag()

	private var muscleList : [Muscle] {
		didSet {
			tableView.reloadData()
		}
	}
	
	init(viewModel: HomeViewModel) {
		self.viewModel = viewModel
		muscleList = [Muscle]()
		
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
		configureTableView()
		
		// FIXME: 이게 맞나..
		directionButton.sendActions(for: .touchUpInside)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let topItem = self.navigationController?.navigationBar.topItem else {
			return
		}
		topItem.title = "몸짱이 되는 길"
	}
	
	private func configureUI() {

		directionButton.layer.cornerRadius = directionButton.frame.width / 2
		directionButton.layer.shadowColor = UIColor.black.cgColor
		directionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
		directionButton.layer.shadowOpacity = 0.4
		directionButton.layer.shadowRadius = 2
	}
	
	private func bind() {
		
		let output = viewModel.transform(input: HomeViewModel.Input(changeDirection: directionButton.rx.tap.asObservable()))
		
		output.muscles
			.withUnretained(self)
			.subscribe(onNext: { owner, items in
				owner.muscleList = items
			})
			.disposed(by: disposeBag)
	}
	
	private func configureTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(UINib(nibName: "MuscleCell", bundle: nil), forCellReuseIdentifier: "MuscleCell")
	}
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.muscleList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MuscleCell", for: indexPath) as! MuscleCell
		cell.bind(name: muscleList[indexPath.row].name)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.coordinatorDelegate?.buttonClicked(muscle: muscleList[indexPath.row])
	}
}
