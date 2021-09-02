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
	func photoLibraryButtonClicked(_ viewController: UIViewController)
	func addExerciseButtonClicked(_ viewController: UIViewController, date: String)
	func readMemoClicked(_ viewController: UIViewController, content: Content)
	func photoDetailClicked(photoIndex: Int, urlString: String)
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
			self.writeMemoButtonClicked.onNext(())
		}
		button.addItem(title: "", image: UIImage(systemName: "photo")) { _ in
			self.photoLibraryButtonClicked.onNext(())
		}
		
		button.addItem(title: "", image: UIImage(systemName: "checkmark")) { _ in
			self.addExerciseButtonClicked.onNext(())
		}
		
		for item in button.items {
			item.imageView.tintColor = .black
		}
		button.isHidden = true
		
		return button
	}()
	
	private let viewModel: CalendarViewModel
	var coordinatorDelegate: CalendarVCCoordinatorDelegate?
	private let disposeBag = DisposeBag()
	
	// event
	private let isScrolled = PublishSubject<Int>()
	private let isAppearView = PublishSubject<Void>()
	let reloadView = PublishSubject<Void>()
	let addedPhotoURL = PublishSubject<NSURL>()
	private let writeMemoButtonClicked = PublishSubject<Void>()
	private let photoLibraryButtonClicked = PublishSubject<Void>()
	private let addExerciseButtonClicked = PublishSubject<Void>()
	
	// present
	private var isFirstAppear = true
    private let cellSpacingHeight: CGFloat = 10
	private var cellSize: CGFloat = 0
	
	private let selectedDateObservable = PublishSubject<String>()
	private var selectedIndexPath = IndexPath()
	
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
        configureNotificationCenter()
		bind()
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if isFirstAppear {
			isScrolled.onNext(0)
			isFirstAppear = false
		}
		
		isAppearView.onNext(())
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
		recordTableView.register(UINib(nibName: ExerciseRecordCell.ID, bundle: nil), forCellReuseIdentifier: ExerciseRecordCell.ID)
		recordTableView.register(UINib(nibName: PhotoCell.ID, bundle: nil), forCellReuseIdentifier: PhotoCell.ID)
	}
	
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveReloadView(_:)), name: .reloadCalendar, object: nil)
    }
    
    @objc func didReceiveReloadView(_ notification: Notification) {
        reloadView.onNext(())
    }
    
	private func bind() {
		
		// viewModel bind
		let output = viewModel.transform(
			input: CalendarViewModel.Input(
				selectedDate: selectedDateObservable.asObservable(),
				addedPhotoURL: addedPhotoURL.asObservable(),
				isScrolled: self.isScrolled.asObservable(),
				isViewAppear: self.isAppearView.asObserver()
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
		
		output.isPhotoAdded
			.subscribe(onNext: { _ in
				self.reloadView.onNext(())
			})
			.disposed(by: disposeBag)
		
		// event bind
		writeMemoButtonClicked
			.withLatestFrom(selectedDateObservable)
			.withUnretained(self)
			.subscribe(onNext: { owner, date in
				owner.coordinatorDelegate?.writeMemoButtonClicked(self, date: date)
			})
			.disposed(by: disposeBag)
		
		photoLibraryButtonClicked
			.withLatestFrom(selectedDateObservable)
			.withUnretained(self)
			.subscribe(onNext: { owner, date in
				owner.coordinatorDelegate?.photoLibraryButtonClicked(self)
			})
			.disposed(by: disposeBag)
		
		addExerciseButtonClicked
			.withLatestFrom(selectedDateObservable)
			.withUnretained(self)
			.subscribe(onNext: { owner, date in
				owner.coordinatorDelegate?.addExerciseButtonClicked(self, date: date)
			})
			.disposed(by: disposeBag)
		
		selectedDateObservable
			.take(1)
			.withUnretained(self)
			.subscribe(onNext: { owner, _ in
				owner.floatingButton.isHidden = false
			})
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
		if scrollView == self.baseCollectionView {
			if scrollView.contentOffset.x  == 0 {
				isScrolled.onNext(-1)
			} else if scrollView.contentOffset.x > view.frame.size.width {
				isScrolled.onNext(1)
			}
		}
	}
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return records.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch records[indexPath.row].type {
		case .Exercise:
			let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseRecordCell.ID, for: indexPath) as! ExerciseRecordCell
			cell.bind(text: records[indexPath.row].text ?? "")
			return cell
		case .Memo:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath) as! MemoCell
			cell.bind(text: records[indexPath.row].text ?? "")
			return cell
		case .Photo:
			let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.ID, for: indexPath) as! PhotoCell
			cell.delegate = self
			cell.bind(url: records[indexPath.row].text, index: indexPath)
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath) as! MemoCell
			cell.bind(text: records[indexPath.row].text ?? "")
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch records[indexPath.row].type {
		case .Memo:
			self.coordinatorDelegate?.readMemoClicked(self, content: records[indexPath.row])
		case .Photo:
			guard let urlString = records[indexPath.row].text else { return }
			self.coordinatorDelegate?.photoDetailClicked(photoIndex: records[indexPath.row].index, urlString: urlString)
		default:
			break
		}
	}
}

extension CalendarViewController: PhotoCellDelegate {
	func resizeImage(indexPath: IndexPath) {
		if self.recordTableView.accessibilityElementCount() >= indexPath.section {
			UIView.performWithoutAnimation {
				self.recordTableView.reloadRows(at: [indexPath], with: .none)
			}
		}
	}
}

extension CalendarViewController: MonthCellDelegate {
	func selectedDate(records: [Content]?, date: String, indexPath: IndexPath) {
		self.records.removeAll()
        if let records = records {
            self.records = records
        }
		self.selectedDateObservable.onNext(date)
		self.selectedIndexPath = indexPath
    }
}
