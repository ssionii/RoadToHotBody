//
//  MuscleCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/13.
//

import UIKit

class MuscleCell: UITableViewCell {

	@IBOutlet weak var muscleName: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func bind(name: String) {
		self.muscleName.text = name
	}
}
