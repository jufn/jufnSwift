//
//  LBFMFavorViewController.swift
//  Jufn@swift
//
//  Created by jufn on 2020/1/2.
//  Copyright © 2020 陈俊峰. All rights reserved.
//

import UIKit

let KFavorViewCellIdentifier: String = "KFavorViewCellIdentifier"

class LBFMFavorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.addSubview(collectionView)
		collectionView.addSubview(header)
        // Do any additional setup after loading the view.
    }
	
	let screen_bounds = UIScreen.main.bounds
	let navHeight: CGFloat = UIScreen.main.bounds.height == 812 ? 88 : 64;
	let titles = ["今日推荐", "南征北战", "最美的期待"]
	
	private lazy var header: LBFMFavorHeaderView = {
		let headerView = LBFMFavorHeaderView.init(frame: CGRect(x: 0, y: 0, width: screen_bounds.width, height: 190))
		headerView.backgroundColor = UIColor.white
		return headerView
	}()
	
	private lazy var collectionView: UICollectionView = {
		
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.scrollDirection = .horizontal
		layout.itemSize = CGSize.init(width: screen_bounds.width, height: screen_bounds.height -  navHeight)
		let collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
		collectionView.frame = view.bounds
		collectionView.contentInset = UIEdgeInsets.init(top: self.header.frame.height, left: 0, bottom: 0, right: 0)
		collectionView.contentInsetAdjustmentBehavior = .never
		collectionView.isPagingEnabled = true
	
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView .register(UICollectionViewCell.self, forCellWithReuseIdentifier: KFavorViewCellIdentifier)
		
		return collectionView
	}()
}

extension LBFMFavorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return titles.count;
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KFavorViewCellIdentifier, for: indexPath)
		cell.backgroundColor = indexPath.row == 0 ? UIColor.brown : UIColor.blue
		return cell
	}
	
}
