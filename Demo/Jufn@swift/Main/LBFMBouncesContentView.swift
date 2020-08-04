//
//  LBFMBouncesContentView.swift
//  Jufn@swift
//
//  Created by admin on 2019/12/14.
//  Copyright © 2019 陈俊峰. All rights reserved.
//

import UIKit

class LBFMBouncesContentView: LBFMBasicContentView {

    public var duration = 3.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
     required init?(coder aDecoder: NSCoder) {
        fatalError("init with adecoder not implement");
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnmation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnmation.duration = duration * 2
        impliesAnmation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnmation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnmation, forKey: "scale")
    }

}
