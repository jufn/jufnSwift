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
	
}

open class LBScrollPageView: UIView {

	weak var delegate: LBScrollPageViewDelegate? {
		didSet {
			let flowLayout: UICollectionViewFlowLayout = titleView.collectionViewLayout as! UICollectionViewFlowLayout
			let width = self.frame.size.width / CGFloat(countOfPage())
			flowLayout.itemSize = CGSize.init(width: width, height: titleCollectionViewHeight());
			containerView.contentSize = CGSize.init(width: self.frame.size.width * CGFloat(countOfPage()), height: containerView.frame.size.height - titleView.frame.size.height)
			guard let view = titleView.viewWithTag(10001)?.subviews.first else {
				return
			}
			let rect = CGRect.init(origin: view.frame.origin, size: CGSize(width: width, height: view.frame.size.height))
			view.frame = rect.insetBy(dx: width * (1 - 0.618) * 0.5, dy: 0)
			layoutSubviewsOfContainerView()
			self.titleView.reloadData()
		}
	}
	var titleViewHeight: CGFloat = 44.0
	var scrollIndicatorHeight: CGFloat = 3.0
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.white
		setupUI()
	}
	
	func setupUI() {
		// title view
		self.addSubview(containerView)
		self.addSubview(titleView)
	}
	
	private func layoutSubviewsOfContainerView() {
		for index in 0 ... countOfPage() - 1 {
			let title_index = delegate?.titles(in: self)[index]
			guard let title = title_index else {
				return
			}
			
			let view = delegate?.scrollPageView(self, contentView: title)
			guard let aView = view else {
				return
			}
			
			aView.frame = CGRect.init(x: CGFloat(index) * self.containerView.frame.size.width, y: 0, width: self.containerView.frame.size.width, height: self.containerView.contentSize.height)
			containerView .addSubview(aView)
		}
	}
	
	private let titleViewCellIdentifier = "UICollectionViewCell"
	private lazy var titleView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		let width = self.frame.size.width / CGFloat(countOfPage());
		flowLayout.itemSize = CGSize.init(width: width, height: titleCollectionViewHeight())
		flowLayout.minimumLineSpacing = 0
		flowLayout.minimumInteritemSpacing = 0

		let titleView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: titleViewHeight), collectionViewLayout: flowLayout)
		titleView.delegate = self
		titleView.backgroundColor = UIColor.clear
		titleView.dataSource = self
		titleView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: titleViewCellIdentifier)
		titleView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: scrollIndicatorHeight, right: 0)
		
		let scrollIndicator = UIScrollView.init(frame: CGRect(x: 0, y: titleCollectionViewHeight(), width: self.frame.size.width, height: scrollIndicatorHeight))
		scrollIndicator.backgroundColor = UIColor.clear
		scrollIndicator.tag = 10001
		let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: scrollIndicatorHeight))
		scrollIndicator.addSubview(view)
		view.backgroundColor = UIColor.orange
		view.layer.cornerRadius = scrollIndicatorHeight * 0.5
		view.layer.masksToBounds = true
		
		titleView.addSubview(scrollIndicator);
		return titleView;
	}()
	
	private lazy var containerView: UIScrollView = {
		let containerView = UIScrollView.init(frame: self.bounds)
		containerView.delegate = self
		containerView.isPagingEnabled = true
		containerView.contentInset = UIEdgeInsets.init(top: titleView.frame.size.height, left: 0, bottom: 0, right: 0)
		containerView.contentSize = CGSize.init(width: self.frame.size.width * CGFloat(countOfPage()), height: containerView.frame.size.height - titleView.frame.size.height)
		return containerView
	}()
	
	private func titleCollectionViewHeight() -> CGFloat {
		return titleViewHeight - scrollIndicatorHeight
	}
	
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
		
		let title_row = delegate?.titles(in: self)[indexPath.row]
		guard let title = title_row else {
			return UICollectionViewCell.init()
		}
		let titleItem: UIView? = delegate?.scrollPageView(self, headerItem: title)
		guard let item = titleItem else {
			return UICollectionViewCell.init()
		}
		item.frame = cell.contentView.bounds;
		cell.contentView.addSubview(item)
		
		return cell
	}
}
