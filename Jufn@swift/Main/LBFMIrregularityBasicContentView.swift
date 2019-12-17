//
//  LBFMIrregularityBasicContentView.swift
//  Jufn@swift
//
//  Created by admin on 2019/12/14.
//  Copyright © 2019 陈俊峰. All rights reserved.
//

import UIKit

class LBFMIrregularityBasicContentView: LBFMBouncesContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.init(white: 175.0/255, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 254.0/255, green: 73/255.0, blue: 42.0/255, alpha: 1.0)
        iconColor = textColor;
        highlightIconColor = textColor;
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented");
    }
}

class LBFMIrregularityContentView: LBFMIrregularityBasicContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.backgroundColor = UIColor.init(red: 250/255.0, green: 48/255.0, blue: 32/255.0, alpha: 1.0)
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.borderColor = UIColor(white: 235/255.0, alpha: 1.0).cgColor
        self.imageView.layer.cornerRadius = 25
        self.insets = UIEdgeInsets.init(top: -23, left: 0, bottom: 0, right: 0)
        self.transform = CGAffineTransform.identity
        self.superview?.bringSubviewToFront(self)
        
        let color = UIColor.init(white: 255.0/255.0, alpha: 1.0)
        
        textColor = color
        highlightTextColor = color
        iconColor = color
        highlightIconColor = color

    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) NO IMPLEMENT")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
        
        return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.frame.size.height / 2.0 - p.y, 2)) < imageView.frame.size.width / 2.0;
    }
    
    override func updateDisplay() {
        super.updateDisplay()
        
        self.imageView.sizeToFit()
        self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
    }
    
}
