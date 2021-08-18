//
//  MonthCell.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/17.
//

import UIKit
import RxSwift
import RxCocoa

class MonthCell: UICollectionViewCell {
    
    static let ID = "MonthCell"
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    private var cellSize: CGFloat = 0
	
	private var viewModel: MonthViewModel?
	private let disposeBag = DisposeBag()
	
	private var calendarDates: [CalendarDate] = [] {
		didSet {
			monthCollectionView.reloadData()
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellSize = contentView.frame.width / 7
        
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
		cell.bind(isThisMonth: self.calendarDates[indexPath.row].isThisMonth, day: self.calendarDates[indexPath.row].dayString , contents: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}
