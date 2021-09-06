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
	private let currentPage = BehaviorSubject<Date>(value: Date())
	private let selectedDateObservable = PublishSubject<String>()
	private let calendarScopeIsWeek = BehaviorSubject<Bool>(value: false)

	// floating button event
	private let writeMemoButtonClicked = PublishSubject<Void>()
	private let photoLibraryButtonClicked = PublishSubject<Void>()
	private let addExerciseButtonClicked = PublishSubject<Void>()
	
	// event
	let reloadView = PublishSubject<Void>()
	let addedPhotoRecordURL = PublishSubject<NSURL>()

	// view
	private var cellSize: CGFloat = 0
	
	private var dateRecords: [String : [Content]] = [:]
	private var selectedDateRecord: [Content] = [] {
		didSet {
			self.recordTableView.reloadData()
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
    
    private func configureUI() {
		
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
	
	private func configureCurrentDate(date: Date) -> String {
		let year = Calendar.current.component(.year, from: date)
		let month = Calendar.current.component(.month, from: date)
		
		return "\(year)년 \(month)월"
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

		guard let topItem = self.navigationController?.navigationBar.topItem else { return }
		
		currentPage
			.withUnretained(self)
			.subscribe(onNext: { owner, date in
				topItem.title = owner.configureCurrentDate(date: date)
			})
			.disposed(by: disposeBag)
		
		// viewModel bind
		let output = viewModel.transform(
			input: CalendarViewModel.Input(
				selectedDate: selectedDateObservable.asObservable(),
				addedPhotoRecordURL: addedPhotoRecordURL.asObservable(),
				currentPage: currentPage.asObserver()
			)
		)
		
		output.dateRecords
			.withUnretained(self)
			.subscribe(onNext: { owner, dateRecords in
				owner.dateRecords = dateRecords
			})
			.disposed(by: disposeBag)
		
		output.isPhotoAdded
			.subscribe(onNext: { _ in
				self.reloadView.onNext(())
			})
			.disposed(by: disposeBag)
		
		// floating button event bind
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
		
		calendarScopeIsWeek
			.distinctUntilChanged()
			.withUnretained(self)
			.subscribe(onNext: { owner, isWeek in
				owner.floatingButton.isHidden = !isWeek
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
		selectedDateObservable.onNext(date.toString)
		selectedDateRecord = self.dateRecords[date.toString] ?? []
	}
	
	func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
		
		return self.dateRecords[date.toString]?.count ?? 0
	}
	
	func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
		
		if calendar.scope == .month {
			calendarScopeIsWeek.onNext(false)
		} else {
			calendarScopeIsWeek.onNext(true)
		}
		
		self.calendarHeight.constant = bounds.height
		self.view.layoutIfNeeded()
	}
	
	func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
		self.currentPage.onNext(calendar.currentPage)
	}
	
	func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
		
		var resultColors = [UIColor]()
		
		let contentType: [ContentType] = [ .Memo, .Exercise, .Photo ]
		let color: [UIColor] = [ .lightGray, UIColor(named: "mainColor") ?? .black , .systemPink ]
		
		
		for (index, type) in contentType.enumerated() {
			if ((self.dateRecords[date.toString]?.contains { $0.type == type }) != nil) {
				resultColors.append(color[index])
			}
		}
		
		return resultColors
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
		return selectedDateRecord.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let record = self.selectedDateRecord[indexPath.row]
		switch record.type {
		case .Exercise:
			let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseRecordCell.ID, for: indexPath) as! ExerciseRecordCell
			cell.bind(text: record.text ?? "")
			return cell
		case .Memo:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath) as! MemoCell
			cell.bind(text: record.text ?? "")
			return cell
		case .Photo:
			let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.ID, for: indexPath) as! PhotoCell
			cell.delegate = self
			cell.bind(url: record.text, index: indexPath)
			return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath) as! MemoCell
			cell.bind(text: record.text ?? "")
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let record = self.selectedDateRecord[indexPath.row]
		switch record.type {
		case .Memo:
			self.coordinatorDelegate?.readMemoClicked(self, content: record)
		case .Photo:
			guard let urlString = record.text else { return }
			self.coordinatorDelegate?.photoDetailClicked(photoIndex: record.index, urlString: urlString)
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
