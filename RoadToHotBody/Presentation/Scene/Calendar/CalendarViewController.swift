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
import FSCalendar

protocol CalendarVCCoordinatorDelegate {
	func writeMemoButtonClicked(_ viewController: UIViewController, date: String)
	func photoLibraryButtonClicked(_ viewController: UIViewController)
	func addExerciseButtonClicked(_ viewController: UIViewController, date: String)
	func readMemoClicked(_ viewController: UIViewController, content: Content)
	func photoDetailClicked(photoIndex: Int, urlString: String)
}

class CalendarViewController: UIViewController {
	
	@IBOutlet weak var calendar: FSCalendar!
	@IBOutlet weak var calendarHeight: NSLayoutConstraint!
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
	
	// calendar event
	private let currentDateString = BehaviorSubject<String>(value: "")

	
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
        configureCalendar()
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
		configureCurrentDate(date: calendar.currentPage)
		floatingButton.display(inViewController: self)
    }
	
	private func configureCalendar() {
		calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 0)
		calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 11)
		calendar.appearance.todayColor = .clear
		calendar.appearance.titleTodayColor = .red
		calendar.appearance.titleFont = UIFont.systemFont(ofSize: 14, weight: .light)
		calendar.appearance.selectionColor = .darkGray
		
		self.cellSize = calendar.frame.width / 7
		calendarHeight.constant = (cellSize - 4) * 7
		
		calendar.locale = Locale(identifier: "ko_KR")
		calendar.addGestureRecognizer(scopeGesture)
		
		calendar.delegate = self
		calendar.dataSource = self
	}
	
	private func configureCurrentDate(date: Date) {
		let year = Calendar.current.component(.year, from: date)
		let month = Calendar.current.component(.month, from: date)
		
		currentDateString.onNext("\(year)년 \(month)월")
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
		
		guard let topItem = self.navigationController?.navigationBar.topItem else { return }
		
		currentDateString
			.subscribe(onNext: { date in
				topItem.title = date
			})
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
	
	fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
		[unowned self] in
		let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
		panGesture.delegate = self
		return panGesture
	}()
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		calendar.setScope(.week, animated: true)
	}
	
	func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
		return 1
	}
	
	func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
		self.calendarHeight.constant = bounds.height
		self.view.layoutIfNeeded()
	}
	
	func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
		self.configureCurrentDate(date: calendar.currentPage)
	}
	
	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
		return [.lightGray, .green, .systemPink ]
	}
	
	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
		return [.lightGray, .green, .systemPink ]
	}
}

extension CalendarViewController: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
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
