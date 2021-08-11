//
//  MemoViewController.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/10.
//

import UIKit

protocol MemoVCCoordinatorDelegate: class {
	
}

enum MemoType {
	case Read
	case Edit
}

class MemoViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
	
	lazy var confirmButton: UIBarButtonItem = {
		let button = UIBarButtonItem(
			title: "완료",
			style: .plain,
			target: self,
			action: #selector(confirmButtonClicked)
		)
		return button
	}()
	
	private var memoType: MemoType
	
	init(memoType: MemoType) {
		self.memoType = memoType
		
		super.init(nibName: "MemoViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
		configureUI()
		keyboardNotification()
    }
	
	private func configureUI() {
		self.navigationItem.rightBarButtonItem = confirmButton
		
		if memoType == MemoType.Edit {
			configureTextView()
		}
	}
	
	private func configureTextView() {
		
		textView.placeholder = "메모를 입력해주세요."
		textView.becomeFirstResponder()
	}
	
	private func keyboardNotification() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
	@objc private func confirmButtonClicked() {
		
		switch memoType {
		case .Read:
			// update
			break
		case .Edit:
			// 새로 저장
			break
		}
	}
	
	@objc private func keyboardWillShow(_ notification: Notification) {
		if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardHeight = keyboardFrame.cgRectValue.height
			textViewBottomConstraint.constant += keyboardHeight
		}
	}
	
	@objc private func keyboardWillHide(_ notification: Notification) {
		if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardHeight = keyboardFrame.cgRectValue.height
			textViewBottomConstraint.constant -= keyboardHeight
		}
	}
}
