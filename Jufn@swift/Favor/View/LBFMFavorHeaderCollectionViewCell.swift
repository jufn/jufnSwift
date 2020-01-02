//
//  LBFMFavorHeaderCollectionViewCell.swift
//  Jufn@swift
//
//  Created by jufn on 2020/1/2.
//  Copyright © 2020 陈俊峰. All rights reserved.
//

import UIKit

class LBFMFavorHeaderCollectionViewCell: UICollectionViewCell {
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		return imageView;
	}()
	
	private lazy var titleLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.font = UIFont.systemFont(ofSize: 13)
		titleLabel.textAlignment = NSTextAlignment.center;
		return titleLabel;
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(self.imageView)
		self.addSubview(self.titleLabel)
		
		let length: CGFloat = 45.0
		let posX = (frame.size.width - length) / 2
		self.imageView.frame = CGRect.init(x: posX, y: 10, width: length, height: length)
		self.titleLabel.frame = CGRect.init(x: 0, y: self.imageView.frame.maxY + 10, width: frame.width, height: 20)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	var dataString: String? {
		didSet {
			self.titleLabel.text = dataString
			self.imageView.image = UIImage(named: dataString!)
		}
	}
}
