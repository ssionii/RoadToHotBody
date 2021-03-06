//
//  MemoCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import UIKit

class MemoCell: UITableViewCell {
	
	static let ID = "MemoCell"
	
	@IBOutlet weak var contentBackgroundView: UIView!
	@IBOutlet weak var memoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
		
		contentBackgroundView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
		contentBackgroundView.backgroundColor = .systemGray6
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
    }
	
	func bind(text: String?) {
		
		guard let text = text else {
			memoLabel.text = ""
			return
		}
		memoLabel.text = text
	}
}
