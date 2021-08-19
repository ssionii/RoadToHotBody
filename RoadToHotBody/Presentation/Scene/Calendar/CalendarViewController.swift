//
//  CalendarViewController.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit
import RxSwift
import RxCocoa

class CalendarViewController: UIViewController {
	
    @IBOutlet weak var baseCollectionView: UICollectionView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
	
	private let viewModel: CalendarViewModel
	private let disposeBag = DisposeBag()
	
	private var cellSize: CGFloat = 0
	
	private let isScrolled = PublishSubject<Int>()
	
	private var displayedMonths : [(Int, Int)]? {
		didSet {
			baseCollectionView.reloadData()
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
		bind()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		isScrolled.onNext(0)
	}
    
    private func configureUI() {
		cellSize = floor((baseCollectionView.frame.size.width - ( 10 * 2 )) / 7)
        calendarHeightConstraint.constant = cellSize * 6
    }
    
    private func configureCollectoinView() {
        baseCollectionView.delegate = self
        baseCollectionView.dataSource = self
        
        baseCollectionView.register(UINib(nibName: MonthCell.ID, bundle: nil), forCellWithReuseIdentifier: MonthCell.ID)
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
