//
//  UITextView+Extension.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/11.
//

import UIKit

extension UITextView: UITextViewDelegate {
	
	/// Resize the placeholder when the UITextView bounds change
	override open var bounds: CGRect {
		didSet {
			self.resizePlaceholder()
		}
	}
	
	/// The UITextView placeholder text
	public var placeholder: String? {
		get {
			var placeholderText: String?
			
			if let placeholderLabel = self.viewWithTag(100) as? UILabel {
				placeholderText = placeholderLabel.text
			}
			
			return placeholderText
		}
		set {
			if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
				placeholderLabel.text = newValue
				placeholderLabel.sizeToFit()
			} else {
				self.addPlaceholder(newValue!)
			}
		}
	}
	
	/// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
	///
	/// - Parameter textView: The UITextView that got updated
	public func textViewDidChange(_ textView: UITextView) {
		if let placeholderLabel = self.viewWithTag(100) as? UILabel {
			placeholderLabel.isHidden = !self.text.isEmpty
		}
	}
	
	/// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
	private func resizePlaceholder() {
		if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
			let labelX = self.textContainer.lineFragmentPadding
			let labelY = self.textContainerInset.top - 2
			let labelWidth = self.frame.width - (labelX * 2)
			let labelHeight = placeholderLabel.frame.height

			placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
		}
	}
	
	/// Adds a placeholder UILabel to this UITextView
	private func addPlaceholder(_ placeholderText: String) {
		let placeholderLabel = UILabel()
		
		placeholderLabel.text = placeholderText
		placeholderLabel.sizeToFit()
		
		placeholderLabel.font = self.font
		placeholderLabel.textColor = UIColor.lightGray
		placeholderLabel.tag = 100
		
		placeholderLabel.isHidden = !self.text.isEmpty
		
		self.addSubview(placeholderLabel)
		self.resizePlaceholder()
		self.delegate = self
	}
	
}
