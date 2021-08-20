//
//  CalendarViewController.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit
import RxSwift
import RxCocoa
import JJFloatingActionButton

protocol CalendarVCCoordinatorDelegate {
	func writeMemoButtonClicked(_ viewController: UIViewController, date: String)
	func photoLibraryButtonClicked(_ viewController: UIViewController, date: String)
	func addExerciseButtonClicked(_ viewController: UIViewController, date: String)
	func readMemoClicked(_ viewController: UIViewController, content: Content)
}

class CalendarViewController: UIViewController {
	
    @IBOutlet weak var baseCollectionView: UICollectionView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var recordTableView: UITableView!
	
	lazy var floatingButton: JJFloatingActionButton = {
		let button = JJFloatingActionButton()
		button.buttonColor = .white
		button.buttonImageColor = .black
		
		button.addItem(title: "", image: UIImage(systemName: "pencil")) { _ in
			self.coordinatorDelegate?.writeMemoButtonClicked(self, date: self.selectedDate)
		}
		button.addItem(title: "", image: UIImage(systemName: "photo")) { _ in
			self.coordinatorDelegate?.photoLibraryButtonClicked(self, date: self.selectedDate)
		}
		
		button.addItem(title: "", image: UIImage(systemName: "checkmark")) { _ in
			self.coordinatorDelegate?.addExerciseButtonClicked(self, date: self.selectedDate)
		}
		
		for item in button.items {
			item.imageView.tintColor = .black
		}
		
		return button
	}()
	
	private let viewModel: CalendarViewModel
	var coordinatorDelegate: CalendarVCCoordinatorDelegate?
	private let disposeBag = DisposeBag()
	
    private let cellSpacingHeight: CGFloat = 10
	private var cellSize: CGFloat = 0
	
	private let isScrolled = PublishSubject<Int>()
	let reloadView = PublishSubject<Void>()
	
	private var displayedMonths: [(Int, Int)]? {
		didSet {
			baseCollectionView.reloadData()
		}
	}
	
	private var records: [Content] = [] {
		didSet {
			recordTableView.reloadData()
		}
	}
	
	private var selectedDate: String = ""
	private var selectedIndexPath: IndexPath = IndexPath()
	
	init(viewModel: CalendarViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "CalendarViewController", bundle: nil)
		self.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 2)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        configureUI()
        configureCollectoinView()
        configureTableView()
		bind()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		isScrolled.onNext(0)
	}
    
    private func configureUI() {
		cellSize = floor((baseCollectionView.frame.size.width - ( 10 * 2 )) / 7)
        calendarHeightConstraint.constant = cellSize * 6
		
		floatingButton.display(inViewController: self)
    }
    
    private func configureCollectoinView() {
        baseCollectionView.delegate = self
        baseCollectionView.dataSource = self
        
        baseCollectionView.register(UINib(nibName: MonthCell.ID, bundle: nil), forCellWithReuseIdentifier: MonthCell.ID)
		
		reloadView
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				(owner.baseCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as! MonthCell).addedRecord.onNext(owner.selectedIndexPath)
			})
			.disposed(by: disposeBag)
    }
	
	private func configureTableView() {
		recordTableView.delegate = self
		recordTableView.dataSource = self
		
		recordTableView.register(UINib(nibName: MemoCell.ID, bundle: nil), forCellReuseIdentifier: MemoCell.ID)
		recordTableView.register(UINib(nibName: ExerciseCell.ID, bundle: nil), forCellReuseIdentifier: ExerciseCell.ID)
	}
	
	private func bind() {
		let output = viewModel.transform(
			input: CalendarViewModel.Input(
				isScrolled: self.isScrolled.asObservable()
			)
		)
		
		output.displayedMonths
			.withUnretained(self)
			.subscribe(onNext: { owner, yearAndMonth in
				owner.displayedMonths = yearAndMonth
				owner.baseCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: false)
			})
			.disposed(by: disposeBag)
		
		guard let topItem = self.navigationController?.navigationBar.topItem else {
			return
		}
		
		output.displayedMonthString
			.drive(topItem.rx.title)
			.disposed(by: disposeBag)
		
	}
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.ID, for: indexPath) as! MonthCell
        cell.delegate = self
		guard let displayedMonths = self.displayedMonths else { return cell }
		cell.bind(viewModel: MonthViewModel(year: displayedMonths[indexPath.row].0, month: displayedMonths[indexPath.row].1))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: cellSize * 6)
    }
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.x  == 0 {
			isScrolled.onNext(-1)
		} else if scrollView.contentOffset.x > view.frame.size.width {
			isScrolled.onNext(1)
		}
	}
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch records[indexPath.section].type {
		case .Exercise:
			let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCell.ID, for: indexPath) as! ExerciseCell
			cell.bind(text: records[indexPath.section].text ?? "")
			return cell
		case .Memo:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath) as! MemoCell
			cell.bind(text: records[indexPath.section].text ?? "")
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath) as! MemoCell
			cell.bind(text: records[indexPath.section].text ?? "")
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch records[indexPath.section].type {
		case .Memo:
			self.coordinatorDelegate?.readMemoClicked(self, content: records[indexPath.section])
		default:
			break
		}
	}
}

extension CalendarViewController: MonthCellDelegate {
	func selectedDate(records: [Content]?, date: String, indexPath: IndexPath) {
        if let records = records {
            self.records = records
        }
		self.selectedDate = date
		self.selectedIndexPath = indexPath
    }
}
