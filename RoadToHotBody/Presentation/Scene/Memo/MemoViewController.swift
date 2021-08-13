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
	func dismissMemo(isSuccess: Bool)
}

class MemoViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var deleteButton: UIButton!
	
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
		
		if viewModel.memoType == MemoType.Write {
			configureTextView()
		}
	}
	
	private func bind() {
		
		let output = viewModel.transfrom(
			input: MemoViewModel.Input(
				confirmButtonClicked: confirmButton.rx.tap.asObservable(),
				deleteButtonClicked: deleteButton.rx.tap.asObservable(),
				text: textView.rx.text.asObservable()
			)
		)
		
		output.text?
			.drive(textView.rx.text)
			.disposed(by: disposeBag)
		
		output.isSaved
			.withUnretained(self)
			.subscribe(onNext: { owner, isSaved in
				owner.coordinatorDelegate?.dismissMemo(isSuccess: isSaved)
			})
			.disposed(by: disposeBag)
		
		output.isDeleted
			.withUnretained(self)
			.subscribe(onNext: { owner, isDeleted in
				owner.coordinatorDelegate?.dismissMemo(isSuccess: isDeleted)
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
			selector: #selector(keyboardWillChangeFrameNotification),
			name: UIResponder.keyboardWillChangeFrameNotification,
			object: nil
		)
	}

	@objc private func keyboardWillChangeFrameNotification(_ notification: Notification) {
		if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardHeight = keyboardFrame.cgRectValue.height
			
			textViewBottomConstraint.constant = keyboardHeight
		}
	}
}
