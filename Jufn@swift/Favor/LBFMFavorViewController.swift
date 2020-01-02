//
//  LBFMFavorViewController.swift
//  Jufn@swift
//
//  Created by jufn on 2020/1/2.
//  Copyright © 2020 陈俊峰. All rights reserved.
//

import UIKit

class LBFMFavorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.addSubview(header)
        // Do any additional setup after loading the view.
    }
	
	let screen_width = UIScreen.main.bounds.width
	
	private lazy var header : LBFMFavorHeaderView = {
		let headerView = LBFMFavorHeaderView.init(frame: CGRect(x: 0, y: 120, width: screen_width, height: 190))
		headerView.backgroundColor = UIColor.white
		return headerView
	}()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
