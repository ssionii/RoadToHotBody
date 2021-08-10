//
//  PhotoCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import UIKit
import SDWebImage

class PhotoCell: UITableViewCell {

	static let ID = "PhotoCell"
	
	@IBOutlet weak var photoBackgroundView: UIView!
	@IBOutlet weak var photoView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		photoBackgroundView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func bind(url: String?) {
		
		guard let url = url else {
			// TODO: default 이미지
			return
		}
		
		photoView.sd_setImage(with: URL(string: url))
	}
}
