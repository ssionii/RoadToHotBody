//
//  WriteMemoViewController.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import UIKit
import RxSwift
import RxCocoa

class WriteMemoViewController: UIViewController {

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
    
    private let viewModel: WriteMemoViewModel
    weak var coordinatorDelegate: MemoVCCoordinatorDelegate?
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: WriteMemoViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: "WriteMemoViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
        keyboardNotification()
    }
    
    private func configureUI() {
        self.navigationItem.rightBarButtonItem = confirmButton
        
        textView.placeholder = "메모를 입력해주세요."
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: WriteMemoViewModel.Input(
                confirmButtonClicked: confirmButton.rx.tap.asObservable(),
                text: textView.rx.text.asObservable()
            )
        )
        
        output.isSaved?
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinatorDelegate?.dismissMemo()
            })
            .disposed(by: disposeBag)
		
		output.title
			.drive(self.navigationItem.rx.title)
			.disposed(by: disposeBag)
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
