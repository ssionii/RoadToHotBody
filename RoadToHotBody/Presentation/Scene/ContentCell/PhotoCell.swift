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
    
    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    
    weak var delegate: PhotoCellDelegate?
    
    private var isReloaded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	override func layoutSubviews() {
		configureUI()
	}
	
	private func configureUI() {
		photoView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
		photoView.layer.masksToBounds = true
	
		let backgroundView = UIView()
		backgroundView.backgroundColor = .clear
		selectedBackgroundView = backgroundView
	}
    
	func bind(url: String?, index: IndexPath) {
		
		guard let url = url else {
			// TODO: Place holder
			return
		}

		SDWebImageManager.shared.loadImage(with: URL(string: url), options: .delayPlaceholder, progress: nil) { image, _, error, _, _, _ in

			if let error = error {
				print(error)
				return
			}

			self.photoView.image = image?.resize(newWidth: self.photoView.frame.width)
			self.delegate?.resizeImage(indexPath: index)
		}
    }
}
