//
//  SelfSizingTableView.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/08/31.
//

import UIKit

class SelfSizingTableView: UITableView {
	let maxHeight: CGFloat = UIScreen.main.bounds.height
	
	override func reloadData() {
		super.reloadData()
		self.invalidateIntrinsicContentSize()
		self.layoutIfNeeded()
	}
	
	override var intrinsicContentSize: CGSize {
		let height = min(contentSize.height, maxHeight)
		return CGSize(width: contentSize.width, height: height)
	}
}
