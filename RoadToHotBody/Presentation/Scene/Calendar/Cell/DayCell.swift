//
//  DayCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/17.
//

import UIKit

class DayCell: UICollectionViewCell {

	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var exerciseView: UIView!
	@IBOutlet weak var memoView: UIView!
	@IBOutlet weak var photoView: UIView!
	
	private var contents: [Content]?

    override func awakeFromNib() {
        super.awakeFromNib()
		
		
    }

	func bind(day: String, contents: [Content]?) {
		self.dayLabel.text = day
		
		self.contents = contents
		
		guard let contents = self.contents else { return }
		if contents.contains(where: { $0.type == .Exercise }) {
			exerciseView.isHidden = false
		} else if contents.contains(where: { $0.type == .Memo }) {
			memoView.isHidden = false
		} else if contents.contains(where: { $0.type == .Photo }) {
			photoView.isHidden = false
		}
	}
}
