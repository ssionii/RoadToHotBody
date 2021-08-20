//
//  DayCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/17.
//

import UIKit
import RxSwift
import RxCocoa

protocol DayCellDelegate: AnyObject {
	func selectedDate(records: [Content]?, date: String, indexPath: IndexPath)
}

class DayCell: UICollectionViewCell {

    static let ID = "DayCell"
    
    @IBOutlet weak var dayLabelBackgroundView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var exerciseView: UIView!
	@IBOutlet weak var memoView: UIView!
	@IBOutlet weak var photoView: UIView!
	
    private var viewModel: DayViewModel?
	private let disposeBag = DisposeBag()
    
    weak var delegate: DayCellDelegate?

	private var indexPath: IndexPath?
    private var isDateSelected = BehaviorSubject<Bool>(value: false)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dayLabelBackgroundView.layer.cornerRadius = self.dayLabelBackgroundView.frame.width / 2
        self.exerciseView.layer.cornerRadius = self.exerciseView.frame.height / 2
        self.exerciseView.backgroundColor = UIColor.init(named: "mainColor")
        self.memoView.layer.cornerRadius = self.memoView.frame.height / 2
		self.memoView.backgroundColor = UIColor.systemGray5
        self.photoView.layer.cornerRadius = self.photoView.frame.height / 2
		self.photoView.backgroundColor = UIColor.systemPink
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                isDateSelected.onNext(true)
				guard let viewModel = viewModel,
					  let indexPath = indexPath else { return }
				delegate?.selectedDate(records: viewModel.records, date: viewModel.calendarDate.date, indexPath: indexPath)
            } else {
                isDateSelected.onNext(false)
            }
        }
    }
	
	func bind(viewModel: DayViewModel, indexPath: IndexPath) {
		
		self.viewModel = viewModel
		self.indexPath = indexPath
		
        let output = viewModel.transform(
            input: DayViewModel.Input(
                viewLoaded: Observable.just(()),
                isDateSelected: isDateSelected.asObservable()
            )
        )
		
		output.textColor
			.subscribe(onNext: { color in
				self.dayLabel.textColor = color
			})
			.disposed(by: disposeBag)
        
        output.textBackgroundColor
            .subscribe(onNext: { color in
                self.dayLabelBackgroundView.backgroundColor = color
            })
            .disposed(by: disposeBag)
		
		output.dayString
			.drive(self.dayLabel.rx.text)
			.disposed(by: disposeBag)
		
		output.hasRecord?
			.subscribe(onNext: { hasRecord in
				self.exerciseView.isHidden = !hasRecord.0
				self.memoView.isHidden = !hasRecord.1
				self.photoView.isHidden = !hasRecord.2
			})
			.disposed(by: disposeBag)
	}
}
