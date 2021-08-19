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
    func selectedDate(records: [Content]?)
}

class MonthCell: UICollectionViewCell {
    
    static let ID = "MonthCell"
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    private var cellWidth: CGFloat = 0
	private var cellHeight: CGFloat = 0
	
	private var viewModel: MonthViewModel?
	private let disposeBag = DisposeBag()
    
    weak var delegate: MonthCellDelegate?
	
	private var calendarDates: [CalendarDate] = [] {
		didSet {
			monthCollectionView.reloadData()
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
		cellWidth = monthCollectionView.frame.width / 7
		cellHeight = monthCollectionView.frame.height / 6
		
        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self
        
        monthCollectionView.register(UINib(nibName: DayCell.ID, bundle: nil), forCellWithReuseIdentifier: DayCell.ID)
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
		cell.bind(viewModel: DayViewModel(calendarDate: calendarDates[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension MonthCell: DayCellDelegate {
    func selectedDate(records: [Content]?) {
        self.delegate?.selectedDate(records: records)
    }
}
