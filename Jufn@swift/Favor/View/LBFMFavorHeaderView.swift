//
//  LBFMFavorHeaderView.swift
//  Jufn@swift
//
//  Created by jufn on 2020/1/2.
//  Copyright © 2020 陈俊峰. All rights reserved.
//

import UIKit

class LBFMFavorHeaderView: UIView {

     // - 发现首页的九宫格分类按钮数据源没抓到，随便搞下
	   //    let imageArray = [
	   //        "http://fdfs.xmcdn.com/group45/M08/74/91/wKgKlFtVs-iBg01bAAAmze4KwRQ177.png",
	   //        "http://fdfs.xmcdn.com/group48/M0B/D9/96/wKgKlVtVs9-TQYseAAAsVyb1apo685.png",
	   //        "http://fdfs.xmcdn.com/group48/M0B/D9/92/wKgKlVtVs9SwvFI6AAAdwAr5vEE640.png",
	   //        "http://fdfs.xmcdn.com/group48/M02/63/E3/wKgKnFtW37mR9fH7AAAcl17u2wA113.png",
	   //        "http://fdfs.xmcdn.com/group46/M09/8A/98/wKgKlltVs3-gubjFAAAxXboXKFE462.png",
	   //        "http://fdfs.xmcdn.com/group45/M08/74/91/wKgKlFtVs-iBg01bAAAmze4KwRQ177.png",
	   //        "http://fdfs.xmcdn.com/group48/M0B/D9/96/wKgKlVtVs9-TQYseAAAsVyb1apo685.png",
	   //        "http://fdfs.xmcdn.com/group48/M0B/D9/92/wKgKlVtVs9SwvFI6AAAdwAr5vEE640.png",
	   //        "http://fdfs.xmcdn.com/group48/M02/63/E3/wKgKnFtW37mR9fH7AAAcl17u2wA113.png",
	   //        "http://fdfs.xmcdn.com/group46/M09/8A/98/wKgKlltVs3-gubjFAAAxXboXKFE462.png"
	   //    ]
	   let dataArray = ["电子书城","全民朗读","大咖主播","活动","直播微课","听单","游戏中心","边听变看","商城","0元购"]
	
	private lazy var collectionView: UICollectionView = {
		let screen_width = UIScreen.main.bounds.size.width
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.itemSize = CGSize(width: screen_width / 5, height: 90)
		
		let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 180), collectionViewLayout: layout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = UIColor.white
		collectionView.register(LBFMFavorHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "LBFMFavorHeaderCollectionViewCell")
		
		return collectionView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(collectionView)
		
		let footer = UIView()
		footer.backgroundColor = UIColor.gray
		footer.frame = CGRect(x: 0, y: frame.height - 10, width: frame.width, height: 10)
		self.addSubview(footer)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

}

extension LBFMFavorHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LBFMFavorHeaderCollectionViewCell", for: indexPath) as! LBFMFavorHeaderCollectionViewCell
		cell.dataString = dataArray[indexPath.row]
		return cell
	}
}
