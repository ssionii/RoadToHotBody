//
//  DetailViewController.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import RxSwift
import RxCocoa
import JJFloatingActionButton

class DetailViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	lazy var doExerciseButton: UIBarButtonItem = {
		let button = UIBarButtonItem(title: "운동하기", style: .plain, target: self, action: nil)
		button.tintColor = UIColor(named: "mainColor")
		
		return button
	}()
    
    lazy var floatingButton: JJFloatingActionButton = {
        let button = JJFloatingActionButton()
        button.buttonColor = UIColor(named: "mainColor") ?? .white
        
        button.addItem(title: "", image: UIImage(systemName: "pencil"), action: nil)
        button.addItem(title: "", image: UIImage(systemName: "photo"), action: nil)
        button.addItem(title: "", image: UIImage(systemName: "video"), action: nil)
        
        return button
    }()
	
	private let viewModel: DetailViewModel
	private let disposeBag = DisposeBag()
	
	private var contents: [Content] = [] {
		didSet {
			self.tableView.reloadData()
		}
	}
	
	init(viewModel: DetailViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "DetailViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		configureUI()
		configureTableView()
		bind()
    }
	
	private func configureUI() {
		self.navigationItem.rightBarButtonItem = doExerciseButton
        
        floatingButton.display(inViewController: self)
	}
	
	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.register(UINib(nibName: MemoCell.ID, bundle: nil), forCellReuseIdentifier: MemoCell.ID)
		tableView.register(UINib(nibName: PhotoCell.ID, bundle: nil), forCellReuseIdentifier: PhotoCell.ID)
	}
	
	private func bind() {
		let output = viewModel.transform(input: DetailViewModel.Input())
		
		output.muscleName
			.drive(self.navigationItem.rx.title)
			.disposed(by: disposeBag)
		
		output.contents
			.compactMap { $0 }
			.withUnretained(self)
			.subscribe(onNext: { owner, contents in
				owner.contents = contents
			})
			.disposed(by: disposeBag)
	}
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contents.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch contents[indexPath.row].type {
		case .Memo:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath) as! MemoCell
			cell.bind(text: contents[indexPath.row].text)
			return cell
		case .Photo:
			let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.ID, for: indexPath) as! PhotoCell
            cell.delegate = self
            cell.bind(url: contents[indexPath.row].url, index: indexPath)
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath)
			return cell
		}
	}
}

extension DetailViewController: PhotoCellDelegate {
    func resizeImage(indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
