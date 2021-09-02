//
//  ExerciseCell.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/09/02.
//

import UIKit

class ExerciseCell: UICollectionViewCell {

	static let ID = "ExerciseCell"
	
	@IBOutlet weak var contentBackgroundView: UIView!
	@IBOutlet weak var exerciseLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	override func layoutSubviews() {
		configureUI()
	}

	func bind(text: String) {
		exerciseLabel.text = text
	}
	
	private func configureUI() {
		contentBackgroundView.layer.cornerRadius = 20
		contentBackgroundView.layer.borderWidth = 1
		contentBackgroundView.layer.borderColor = UIColor(named: "mainColor")?.cgColor
	
	}
}
