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
    
    weak var delegate: PhotoCellDelegate?
    
    private var isReloaded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        photoView.layer.masksToBounds = true
    
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(url: String?, index: IndexPath) {
        guard let url = url else {
            // TODO: default 이미지
            return
        }
        
        photoView.sd_setImage(with: URL(string: url)) { [weak self] image, _, _, _ in
            guard let self = self else { return }
            
            self.photoView.image = image?.resize(newWidth: self.photoView.frame.width)
            self.delegate?.resizeImage(indexPath: index)
        }
    }
}
