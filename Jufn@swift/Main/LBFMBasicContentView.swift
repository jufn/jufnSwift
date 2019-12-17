//
//  LBFMBasicContentView.swift
//  Jufn@swift
//
//  Created by admin on 2019/12/14.
//  Copyright © 2019 陈俊峰. All rights reserved.
//

import ESTabBarController_swift

class LBFMBasicContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.init(white: 175 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0);
        iconColor = textColor;
        highlightIconColor = highlightTextColor;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
