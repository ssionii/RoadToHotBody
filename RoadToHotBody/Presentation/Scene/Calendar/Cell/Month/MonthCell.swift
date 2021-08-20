//
//  MonthCell.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/17.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol MonthCellDelegate: AnyObject {
	func selectedDate(records: [Content]?, date: String, indexPath: IndexPath)
}

class MonthCell: UICollectionViewCell {
    
    static let ID = "MonthCell"
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    private var cellWidth: CGFloat = 0
	private var cellHeight: CGFloat = 0
	
	private var viewModel: MonthViewModel?
	private let disposeBag = DisposeBag()
    
    weak var delegate: MonthCellDelegate?
	
	let addedRecord = PublishSubject<IndexPath>()
	
	private var calendarDates: [CalendarDate] = [] {
		didSet {
			monthCollectionView.reloadData()
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
		cellWidth = monthCollectionView.frame.width / 7
		cellHeight = monthCollectionView.frame.height / 6
		
		configureCollectionView()
    }
	
	private func configureCollectionView() {
		monthCollectionView.dataSource = self
		monthCollectionView.delegate = self
		
		monthCollectionView.register(UINib(nibName: DayCell.ID, bundle: nil), forCellWithReuseIdentifier: DayCell.ID)
		
		addedRecord
			.withUnretained(self)
			.subscribe(onNext: { owner, indexPath in
				owner.monthCollectionView.reloadItems(at: [indexPath])
				(owner.monthCollectionView.cellForItem(at: indexPath))?.isSelected = true
				owner.monthCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
			}).disposed(by: disposeBag)
	}
	
	func bind(viewModel: MonthViewModel) {
		self.viewModel = viewModel
		
		let output = viewModel.transform(input: MonthViewModel.Input())
		
		output.calendarDates
			.subscribe(onNext: { dates in
				self.calendarDates = dates
			})
			.disposed(by: disposeBag)
	}
}

extension MonthCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.calendarDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.ID, for: indexPath) as! DayCell
        cell.delegate = self
		cell.bind(viewModel: DayViewModel(calendarDate: calendarDates[indexPath.row]), indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MonthCell: DayCellDelegate {
	func selectedDate(records: [Content]?, date: String, indexPath: IndexPath) {
		self.delegate?.selectedDate(records: records, date: date, indexPath: indexPath)
    }
}
