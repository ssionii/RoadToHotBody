//
//  MemoViewController.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/10.
//

import UIKit
import RxSwift
import RxCocoa

protocol MemoVCCoordinatorDelegate: class {
	func dismissMemo(isSaved: Bool)
}

class MemoViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
	
	lazy var confirmButton: UIBarButtonItem = {
		let button = UIBarButtonItem(
			title: "완료",
			style: .plain,
			target: self,
			action: nil
		)
		return button
	}()
	
	private let viewModel: MemoViewModel
	weak var coordinatorDelegate: MemoVCCoordinatorDelegate?
	
	private let disposeBag = DisposeBag()
	private let tapButton = PublishSubject<Void>()
	
	init(viewModel: MemoViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "MemoViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        
		configureUI()
		keyboardNotification()
		bind()
    }
	
	private func configureUI() {
		self.navigationItem.rightBarButtonItem = confirmButton
		
		if viewModel.memoType == MemoType.Write ||
		   viewModel.memoType == MemoType.Edit {
			configureTextView()
		}
	}
	
	private func bind() {
		
		let output = viewModel.transfrom(
			input: MemoViewModel.Input(
				confirmButtonClicked: confirmButton.rx.tap.asObservable(),
				text: textView.rx.text.asObservable()
			)
		)
		
		output.text?
			.drive(textView.rx.text)
			.disposed(by: disposeBag)
		
		output.isSaved
			.withUnretained(self)
			.subscribe(onNext: { owner, isSaved in
				owner.coordinatorDelegate?.dismissMemo(isSaved: isSaved)
			})
			.disposed(by: disposeBag)
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
