//
//  ExerciseCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/19.
//

import UIKit

class ExerciseCell: UITableViewCell {

	static let ID = "ExerciseCell"
	
	@IBOutlet weak var exerciseBackgroundView: UIView!
	@IBOutlet weak var exerciseLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		exerciseBackgroundView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
		exerciseBackgroundView.backgroundColor = UIColor.init(named: "mainColor")
        exerciseLabel.textColor = .white
        
		let backgroundView = UIView()
		backgroundView.backgroundColor = .clear
		selectedBackgroundView = backgroundView
    }
	
	func bind(text: String) {
		self.exerciseLabel.text = text
	}
}
