//
//  PhotoCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/10.
//

import UIKit
import SDWebImage

protocol PhotoCellDelegate: AnyObject {
    func resizeImage(indexPath: IndexPath)
}

class PhotoCell: UITableViewCell {

	static let ID = "PhotoCell"
	
	@IBOutlet weak var photoBackgroundView: UIView!
	@IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoViewHeight: NSLayoutConstraint!
    
    private var image: UIImage?
    
    weak var delegate: PhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
		
        photoView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        photoView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
    func bind(url: String?, index: IndexPath) {
		
		guard let url = url else {
			// TODO: default 이미지
			return
		}
		
        photoView.sd_setImage(with: URL(string: url)) { _, _, _, _ in
            guard let image = self.photoView.image else { return }
            let height = (image.size.height * self.photoView.frame.width ) / image.size.width
            
            self.photoViewHeight.constant = height
            self.delegate?.resizeImage(indexPath: index)
        }
	}
}
