//
//  LBScrollPageView.swift
//  Jufn@swift
//
//  Created by jufn on 2020/1/9.
//  Copyright © 2020 陈俊峰. All rights reserved.
//

import UIKit

public protocol LBScrollPageViewDelegate: NSObjectProtocol {
	
	func titles(in scrollPageView: LBScrollPageView) -> Array<String>
	
	func scrollPageView(_ scrollPageView: LBScrollPageView, headerItem AtTitle: String) -> UIView // headerItem
	
	func scrollPageView(_ scrollPageView: LBScrollPageView, tapAt headerItem: UIView) /// 点击headerItem
	
	func scrollPageView(_ scrollPageView: LBScrollPageView, contentView AtTitle: String) -> UIView // content view
	
	func scrollPageView(_ scrollPageView: LBScrollPageView, contentViewController AtTitle: String) -> UIViewController
	
}

open class LBScrollPageView: UIView {

	weak var delegate: LBScrollPageViewDelegate? {
		didSet {
		 setupUI()
		}
	}
	var titleViewHeight: CGFloat?
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	func setupUI() {
		
		// title view
		
		
		
	}
	
	private let titleViewCellIdentifier = "UICollectionViewCell"
	
	private lazy var titleView: UICollectionView = {
		
		let height = titleViewHeight ?? 44
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize.init(width: self.frame.size.width / CGFloat(countOfPage()), height: height)
		flowLayout.minimumLineSpacing = 0
		flowLayout.minimumInteritemSpacing = 0

		let titleView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: height), collectionViewLayout: flowLayout)
		titleView.delegate = self
		titleView.dataSource = self
		titleView .register(UICollectionViewCell.self, forCellWithReuseIdentifier: titleViewCellIdentifier)
		
		return titleView;
	}()
	
	private lazy var containerView: UIScrollView = {
		let containerView = UIScrollView.init(frame: self.bounds)
		containerView.delegate = self
		containerView.isPagingEnabled = true
		containerView.contentInset = UIEdgeInsets.init(top: titleView.frame.size.height, left: 0, bottom: 0, right: 0)
		containerView.contentSize = CGSize.init(width: self.frame.size.width * CGFloat(countOfPage()), height: containerView.frame.size.height)
		
		return containerView
		
	}()
	
	private func countOfPage() -> Int {
		let count = delegate?.titles(in: self).count
		return count ?? 1
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}

extension LBScrollPageView: UICollectionViewDelegate, UICollectionViewDataSource {
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return countOfPage()
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleViewCellIdentifier, for: indexPath)
		cell.backgroundColor = UIColor.orange
		return cell
	}
	
	
	
}
