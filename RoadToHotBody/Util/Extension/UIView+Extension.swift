//
//  UIView+Extension.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/06.
//

import UIKit

extension UIView {
	/// UIView 모서리의 라운드 처리 함수
	/// ex) roundCorners([.topLeft, .topRight], radius: 15)
	func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
		if #available(iOS 11.0, *) {
			self.layer.cornerRadius = radius
			var masked = CACornerMask()
			if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
			if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
			if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
			if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
			self.layer.maskedCorners = masked
		} else {
			let size = CGSize(width: radius, height: radius)
			let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
			let shapeLayer = CAShapeLayer()
			shapeLayer.frame = self.bounds
			shapeLayer.path = bezierPath.cgPath
			self.layer.mask = shapeLayer
		}
	}
}
