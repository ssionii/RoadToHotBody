//
//  VideoCell.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/16.
//

import UIKit
import AVKit

class VideoCell: UITableViewCell {
    
    static let ID = "VideoCell"
    
    @IBOutlet weak var thumbnailView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(url: String?) {
        
        guard let urlString = url else { return }
        guard let url = URL(string: urlString) else { return }
        
        getThumbnailImageFromVideoUrl(url: url) { [weak self] thumbnail in
            guard let self = self else { return }
            self.thumbnailView.image = thumbnail
        }
        
//        let player = AVPlayer(url: url)
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?) -> Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
