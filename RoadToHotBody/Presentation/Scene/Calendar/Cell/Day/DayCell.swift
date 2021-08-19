//
//  DayCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/17.
//

import UIKit
import RxSwift
import RxCocoa

class DayCell: UICollectionViewCell {

    static let ID = "DayCell"
    
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var exerciseView: UIView!
	@IBOutlet weak var memoView: UIView!
	@IBOutlet weak var photoView: UIView!
	
	private var contents: [Content]?
	
	private var viewModel: DayViewModel?
	private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
		
        self.exerciseView.layer.cornerRadius = self.exerciseView.frame.height / 2
        self.exerciseView.backgroundColor = UIColor.init(named: "mainColor")
        self.memoView.layer.cornerRadius = self.memoView.frame.height / 2
		self.memoView.backgroundColor = UIColor.systemGray5
        self.photoView.layer.cornerRadius = self.photoView.frame.height / 2
		self.photoView.backgroundColor = UIColor.systemPink
    }
	
	func bind(viewModel: DayViewModel) {
		
		self.viewModel = viewModel
		
		let output = viewModel.transform(input: DayViewModel.Input())
		
		output.textColor
			.subscribe(onNext: { color in
				self.dayLabel.textColor = color
			})
			.disposed(by: disposeBag)
		
		output.dayString
			.drive(self.dayLabel.rx.text)
			.disposed(by: disposeBag)
		
		output.hasExerciseRecord
			.subscribe(onNext: { bool in
				self.exerciseView.isHidden = !bool
			})
			.disposed(by: disposeBag)
		
		output.hasMemoRecord
			.subscribe(onNext: { bool in
				self.memoView.isHidden = !bool
			})
			.disposed(by: disposeBag)
		
		output.hasPhotoRecord
			.subscribe(onNext: { bool in
				self.photoView.isHidden = !bool
			})
			.disposed(by: disposeBag)
	}
}
