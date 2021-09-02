//
//  DetailViewController.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import Foundation
import RxSwift
import RxCocoa
import JJFloatingActionButton
import AVKit
import Photos
import SDWebImage

protocol DetailVCCoordinatorDelegate: AnyObject {
    func readMemo(_ parentViewController: DetailViewController, content: Content)
    func writeMemoButtonClicked(_ parentViewController: DetailViewController)
    func photoLibraryButtonClicked(_ parentViewController: DetailViewController)
	func photoDetailClicked(photoIndex: Int, imageUrlString: String)
}

class DetailViewController: UIViewController {
	
	private lazy var tableView: SelfSizingTableView = {
		let tableView = SelfSizingTableView()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.showsVerticalScrollIndicator = false
		return tableView
	}()
	
	private lazy var floatingButton: JJFloatingActionButton = {
		let button = JJFloatingActionButton()
		button.buttonColor = UIColor(named: "mainColor") ?? .white
		
		button.addItem(title: "", image: UIImage(systemName: "pencil")) { _ in
			self.coordinatorDelegate?.writeMemoButtonClicked(self)
		}
		button.addItem(title: "", image: UIImage(systemName: "photo")) { _ in
			self.coordinatorDelegate?.photoLibraryButtonClicked(self)
		}
//        button.addItem(title: "", image: UIImage(systemName: "video"), action: nil)
		
		return button
	}()
	
	lazy var doExerciseButton: UIBarButtonItem = {
		let button = UIBarButtonItem(title: "운동하기", style: .plain, target: self, action: #selector(doExerciseButtonClicked))
		button.tintColor = UIColor(named: "mainColor")
		
		return button
	}()
    

	private let viewModel: DetailViewModel
    weak var coordinatorDelegate: DetailVCCoordinatorDelegate?
	private let disposeBag = DisposeBag()
	
	let reloadView = BehaviorSubject<Void>(value: ())
	let doExercise = PublishSubject<Void>()
    let addedPhotoURL = PublishSubject<NSURL>()
    let addedVideoURL = PublishSubject<NSURL>()
	
	private var contents: [Content] = [] {
		didSet {
			self.tableView.reloadData()
		}
	}
	
	private var prefetchedImage: [IndexPath : UIImage] = [:]
	
	init(viewModel: DetailViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "DetailViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
	
		configureTableView()
		configureUI()
		bind()
//		requestPermssion()
    }
	
	private func configureUI() {
		self.navigationItem.rightBarButtonItem = doExerciseButton
        floatingButton.display(inViewController: self)
	}
	
	private func requestPermssion() {
		PHPhotoLibrary.requestAuthorization { status in
			switch status {
			case .authorized:
				print("갤러리 권한 허용")
				OperationQueue.main.addOperation {
					self.reloadView.onNext(())
				}
			case .denied:
				print("갤러리 권한 거부")
			case .restricted, .notDetermined:
				print("갤러리 선택하지 않음")
			default:
				break
			}
		}
	}
	
	private func configureTableView() {
		
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		tableView.register(UINib(nibName: MemoCell.ID, bundle: nil), forCellReuseIdentifier: MemoCell.ID)
		tableView.register(UINib(nibName: PhotoCell.ID, bundle: nil), forCellReuseIdentifier: PhotoCell.ID)
		tableView.register(UINib(nibName: VideoCell.ID, bundle: nil), forCellReuseIdentifier: VideoCell.ID)
	}
	
	private func bind() {
		let output = viewModel.transform(
			input: DetailViewModel.Input(
                reloadView: reloadView.asObserver(),
                addedPhotoURL: addedPhotoURL.asObserver(),
                addedVideoURL: addedVideoURL.asObserver(),
				doExercise: doExercise.asObservable()
            )
		)
		
		output.muscleName
			.drive(self.navigationItem.rx.title)
			.disposed(by: disposeBag)
		
		output.contents
			.compactMap { $0 }
			.withUnretained(self)
			.subscribe(onNext: { owner, contents in
				owner.contents = contents
			})
			.disposed(by: disposeBag)
        
        output.isPhotoAdded
            .subscribe(onNext: { _ in
                self.reloadView.onNext(())
            })
            .disposed(by: disposeBag)
        
        output.isVideoAdded
            .subscribe(onNext: { _ in
                self.reloadView.onNext(())
            })
            .disposed(by: disposeBag)
		
		output.doExercise
			.subscribe(onNext: { _ in
				print("운동 시작 등록 완료")
                NotificationCenter.default.post(name: .reloadCalendar, object: nil)
			})
			.disposed(by: disposeBag)
	}
	
	@objc private func doExerciseButtonClicked(_ sender: Any) {
		let alert = UIAlertController(title: "운동 기록 하시겠습니까?", message: "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "네", style: .default, handler: { [weak self ] _ in
			guard let self = self else { return }
			self.doExercise.onNext(())
		}))
		alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
		
		present(alert, animated: false, completion: nil)
	}
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contents.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch contents[indexPath.row].type {
		case .Memo:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath) as! MemoCell
            cell.bind(text: contents[indexPath.row].text)
			return cell
		case .Photo:
			let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.ID, for: indexPath) as! PhotoCell
            cell.delegate = self
			cell.bind(url: contents[indexPath.row].text, index: indexPath)
			return cell
        case .Video:
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.ID, for: indexPath) as! VideoCell
			cell.delegate = self
			cell.bind(url: contents[indexPath.row].text, indexPath: indexPath)
            return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath)
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch contents[indexPath.row].type {
		case .Memo:
			self.coordinatorDelegate?.readMemo(self, content: contents[indexPath.row])
			break
		case .Photo:
			guard let urlString = contents[indexPath.row].text else { return }
			self.coordinatorDelegate?.photoDetailClicked(photoIndex: contents[indexPath.row].index, imageUrlString: urlString)
			break
		default:
			break
		}
	}
}

extension DetailViewController: PhotoCellDelegate {
    func resizeImage(indexPath: IndexPath) {
        UIView.performWithoutAnimation {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension DetailViewController: VideoCellDelegate {
	func loadedThumbnail(indexPath: IndexPath) {
		
		UIView.performWithoutAnimation {
			self.tableView.reloadRows(at: [indexPath], with: .none)
		}
	}
}
