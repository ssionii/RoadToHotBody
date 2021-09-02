//
//  ExerciseListViewController.swift
//  RoadToHotBody
//
//  Created by Yang Siyeon on 2021/09/02.
//

import UIKit
import MaterialComponents

class ExerciseListViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBOutlet weak var completeButton: UIButton!
	@IBAction func completeButtonClicked(_ sender: Any) {
		
	}
	
	private var exercises: [String] = ["야호", "무야호"]
	
	override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	private func configureUI() {
		completeButton.layer.cornerRadius = 20
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.register(UINib(nibName: ExerciseCell.ID, bundle: nil), forCellWithReuseIdentifier: ExerciseCell.ID)
	}
}

extension ExerciseListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return exercises.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExerciseCell.ID, for: indexPath) as! ExerciseCell
		cell.bind(text: exercises[indexPath.row])
		return cell
	}
}
