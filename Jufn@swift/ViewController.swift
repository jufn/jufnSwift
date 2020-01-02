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
		demo1()
    }
	
	func demo1() {
		let stname = "swift"
		let mark1 = 98
		let mark2 = 89
		let mark3 = 76
		
		let st1 = StudentDetails(stname: stname, mark1: mark1, mark2: mark2, mark3: mark3)
		print(st1.stname ?? "s")
		print(st1.mark1 ?? 8)
		
	}
	
	func loadupUI() {
		
		let incrementByTen = makeIncrementor(forIncrement: 10)
		print(incrementByTen())
		print(incrementByTen())
		print(incrementByTen())
		print(incrementByTen())
		
		let alsoIncrementorByTen = incrementByTen;
		print(alsoIncrementorByTen())
	}
	
	func makeIncrementor(forIncrement amount: Int) -> () -> Int {
		var runningTotal = 0
		func incrementor() -> Int {
			runningTotal += amount
			return runningTotal
		}
		return incrementor
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		loadupUI()
	}

}

class StudentDetails {
	var stname: String!
	var mark1: Int!
	var mark2: Int!
	var mark3: Int!
	init(stname: String, mark1: Int, mark2: Int, mark3: Int) {
		self.stname = stname
		self.mark1 = mark1;
		self.mark2 = mark2
		self.mark3 = mark3
	}
}


