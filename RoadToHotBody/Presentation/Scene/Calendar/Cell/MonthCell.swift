//
//  MonthCell.swift
//  RoadToHotBody
//
//  Created by 양시연 on 2021/08/17.
//

import UIKit

class MonthCell: UICollectionViewCell {
    
    static let ID = "MonthCell"
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    
    private var cellSize: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellSize = contentView.frame.width / 7
        
        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self
        
        monthCollectionView.register(UINib(nibName: DayCell.ID, bundle: nil), forCellWithReuseIdentifier: DayCell.ID)
    }
}

extension MonthCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 * 6 // 6주
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.ID, for: indexPath) as! DayCell
        cell.bind(day: String(indexPath.row), contents: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}
