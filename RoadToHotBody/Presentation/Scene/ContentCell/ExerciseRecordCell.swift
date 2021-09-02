//
//  ExerciseRecordCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import UIKit

class ExerciseRecordCell: UITableViewCell {

	static let ID = "ExerciseRecordCell"
	
	@IBOutlet weak var contentBackgroundView: UIView!
	@IBOutlet weak var exerciseLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		contentBackgroundView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
		contentBackgroundView.backgroundColor = UIColor.init(named: "mainColor")
        exerciseLabel.textColor = .white
        
		let backgroundView = UIView()
		backgroundView.backgroundColor = .clear
		selectedBackgroundView = backgroundView
    }
	
	func bind(text: String) {
		self.exerciseLabel.text = text
	}
}
