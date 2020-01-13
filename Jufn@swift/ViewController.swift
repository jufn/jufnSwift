//
//  ViewController.swift
//  Jufn@swift
//
//  Created by admin on 2019/12/14.
//  Copyright © 2019 陈俊峰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.view.addSubview(pageView)
    }
	
	private lazy var pageView: LBScrollPageView = {
		let pageView = LBScrollPageView.init(frame: CGRect.init(x: 0, y: 88, width: self.view.frame.size.width, height: self.view.frame.size.height - 88))
		pageView.delegate = self;
		return pageView;
	}()
}

extension ViewController: LBScrollPageViewDelegate {
	func titles(in scrollPageView: LBScrollPageView) -> Array<String> {
		return ["关注动态", "推荐动态", "趣配音"]
	}
	
	func scrollPageView(_ scrollPageView: LBScrollPageView, headerItem AtTitle: String) -> UIView {
		let lab = UILabel()
		lab.text = AtTitle
		lab.textAlignment = .center
		lab.textColor = UIColor.darkText
		return lab
	}
	
	func scrollPageView(_ scrollPageView: LBScrollPageView, tapAt headerItem: UIView) {
		
	}
	
	func scrollPageView(_ scrollPageView: LBScrollPageView, contentView AtTitle: String) -> UIView {
		let titles = self .titles(in: scrollPageView)
		let index = titles.firstIndex(of: AtTitle)
		
		var view: UIView?
		if index == 0 {
			view = LBTimeLineAttentionView()
			view?.backgroundColor = UIColor.orange
		} else if index == 1 {
			view = LBTimeLineRecommendView()
			view?.backgroundColor = UIColor.blue
		} else if index == 2 {
			view = LBFunDubbingView()
			view?.backgroundColor = UIColor.purple
		}
		return view!;
	}
	
}


