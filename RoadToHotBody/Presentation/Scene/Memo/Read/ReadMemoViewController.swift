//
//  ReadMemoViewController.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/14.
//

import UIKit
import RxSwift
import RxCocoa

class ReadMemoViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    
    lazy var confirmButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: nil
        )
        button.isEnabled = false
        return button
    }()
    
    private let viewModel: ReadMemoViewModel
    weak var coordinatorDelegate: MemoVCCoordinatorDelegate?
    
    private let disposeBag = DisposeBag()
    private let tapButton = PublishSubject<Void>()
    
    init(viewModel: ReadMemoViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: "ReadMemoViewController", bundle: nil)
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
    }
    
    private func bind() {
        let output = viewModel.transform(
            input: ReadMemoViewModel.Input(
                confirmButtonClicked: confirmButton.rx.tap.asObservable(),
                deleteButtonClicked: deleteButton.rx.tap.asObservable(),
                text: textView.rx.text.asObservable()
            )
        )
        
        output.text?
            .drive(textView.rx.text)
            .disposed(by: disposeBag)
        
        output.isEditType
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.confirmButton.isEnabled = true
                owner.deleteButton.isHidden = true
            })
            .disposed(by: disposeBag)
        
        output.isUpdated?
            .withUnretained(self)
            .subscribe(onNext: { owner, isUpdated in
                owner.coordinatorDelegate?.dismissMemo()
            })
            .disposed(by: disposeBag)
        
        output.isDeleted?
            .withUnretained(self)
            .subscribe(onNext: { owner, isDeleted in
                owner.coordinatorDelegate?.dismissMemo()
            })
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
            
            textViewBottomLayout.constant = keyboardHeight
        }
    }
}
