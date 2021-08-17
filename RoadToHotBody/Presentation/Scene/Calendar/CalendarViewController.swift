//
//  CalendarViewController.swift
//  RoadToHotBody
//
//  Created by  60117280 on 2021/08/09.
//

import UIKit

class CalendarViewController: UIViewController {
	
    @IBOutlet weak var baseCollectionView: UICollectionView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    private var cellSize: CGFloat = 0
	
	init() {
		super.init(nibName: "CalendarViewController", bundle: nil)
	
		self.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 2)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        configureCollectoinView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        baseCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .right, animated: false)
    }
    
    private func configureUI() {
        cellSize = (view.frame.width - ( 10 * 2 )) / 7
        calendarHeightConstraint.constant = cellSize * 6
    }
    
    private func configureCalendar() {
        
        var currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentMonthIndex -= 1
        
//        let currentYear = Calendar.current.component(.year, from: Date())
//        let todaysDate = Calendar.current.component(.day, from: Date())
//
//        print("numOfDaysThisMonth : \(numOfDaysInMonth[currentMonthIndex])" )
//        print("\ncurrentYear : \(currentYear)")
//
//        if currentYear % 4 == 0 {
//            numOfDaysInMonth[currentMonthIndex] = 29
//        }
//
//        presentMonthIndex = currentMonthIndex
//        presentYear = currentYear
//
//        topMonthButton.setTitle("\(months[currentMonthIndex]) \(currentYear)", for: .normal)
        
    }
    
    private func configureCollectoinView() {
        baseCollectionView.delegate = self
        baseCollectionView.dataSource = self
        
        baseCollectionView.register(UINib(nibName: MonthCell.ID, bundle: nil), forCellWithReuseIdentifier: MonthCell.ID)
    }
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.ID, for: indexPath) as! MonthCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: cellSize * 6)
    }
}
