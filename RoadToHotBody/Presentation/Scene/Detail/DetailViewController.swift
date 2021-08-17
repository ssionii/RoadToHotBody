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

protocol DetailVCCoordinatorDelegate: AnyObject {
    func readMemo(_ parentViewController: DetailViewController, content: Content)
    func writeMemoButtonClicked(_ parentViewController: DetailViewController)
    func photoLibraryButtonClicked(_ parentViewController: DetailViewController)
}

class DetailViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	lazy var doExerciseButton: UIBarButtonItem = {
		let button = UIBarButtonItem(title: "운동하기", style: .plain, target: self, action: nil)
		button.tintColor = UIColor(named: "mainColor")
		
		return button
	}()
    
    lazy var floatingButton: JJFloatingActionButton = {
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
	
	private let viewModel: DetailViewModel
    weak var coordinatorDelegate: DetailVCCoordinatorDelegate?
	private let disposeBag = DisposeBag()
	
	let reloadView = PublishSubject<Void>()
    let addedPhotoURL = PublishSubject<NSURL>()
    let addedVideoURL = PublishSubject<NSURL>()
    
    private let cellSpacingHeight: CGFloat = 10
	
	private var contents: [Content] = [] {
		didSet {
			self.tableView.reloadData()
		}
	}
	
	init(viewModel: DetailViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: "DetailViewController", bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
	
		configureUI()
		configureTableView()
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
		tableView.delegate = self
		tableView.dataSource = self
        
		tableView.register(UINib(nibName: MemoCell.ID, bundle: nil), forCellReuseIdentifier: MemoCell.ID)
		tableView.register(UINib(nibName: PhotoCell.ID, bundle: nil), forCellReuseIdentifier: PhotoCell.ID)
		tableView.register(UINib(nibName: VideoCell.ID, bundle: nil), forCellReuseIdentifier: VideoCell.ID)
	}
	
	private func bind() {
		let output = viewModel.transform(
			input: DetailViewModel.Input(
                reloadView: reloadView.asObserver(),
                addedPhotoURL: addedPhotoURL.asObserver(),
                addedVideoURL: addedVideoURL.asObserver()
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
		
		reloadView.subscribe(onNext: { _ in
			print("realod view called")
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
	}
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
	
    func numberOfSections(in tableView: UITableView) -> Int {
        return contents.count
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch contents[indexPath.section].type {
		case .Memo:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath) as! MemoCell
            cell.bind(text: contents[indexPath.section].text)
			return cell
		case .Photo:
			let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.ID, for: indexPath) as! PhotoCell
            cell.delegate = self
            cell.bind(url: contents[indexPath.section].text, index: indexPath)
			return cell
        case .Video:
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.ID, for: indexPath) as! VideoCell
			cell.delegate = self
			cell.bind(url: contents[indexPath.section].text, indexPath: indexPath)
            return cell
		default:
			let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.ID, for: indexPath)
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch contents[indexPath.row].type {
		case .Memo:
			self.coordinatorDelegate?.readMemo(self, content: contents[indexPath.section])
			break
		case .Photo:
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
