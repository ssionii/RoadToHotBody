//
//  VideoCell.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/17.
//

import UIKit
import AVKit
import RxSwift

protocol VideoCellDelegate: AnyObject {
	func loadedThumbnail(indexPath: IndexPath)
}

class VideoCell: UITableViewCell {
	
	static let ID = "VideoCell"
	
	weak var delegate: VideoCellDelegate?
	private let disposeBag = DisposeBag()
	
	var playerLayer: AVPlayerLayer?
	var player: AVPlayer?

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func bind(url: String?, indexPath: IndexPath) {
		
		guard let urlString = url else { return }
		guard let url = URL(string: urlString) else { return }
		
		player = AVPlayer(url: url)
		playerLayer = AVPlayerLayer(player: player)
		playerLayer?.frame = bounds
		playerLayer?.videoGravity = AVLayerVideoGravity.resize
		if let playerLayer = self.playerLayer {
			layer.addSublayer(playerLayer)
		}
		
	}
	
	func thumbnailImage(from url: URL) -> Observable<UIImage> {
		
		Observable.create { observer in
			
			let asset = AVAsset(url: url)
			let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
			avAssetImageGenerator.appliesPreferredTrackTransform = true
			let times = [NSValue(time: CMTime(seconds: 0.0, preferredTimescale: 1))]
				
			avAssetImageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, image, _, _, error in
					
				if let image = image {
					observer.onNext(UIImage(cgImage: image))
				}
				
				if let error = error {
					observer.onError(error)
				}
			}
			
			return Disposables.create { }
		}
	}
}
