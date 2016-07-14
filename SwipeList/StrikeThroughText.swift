//
//  StrikeThroughText.swift
//  SwipeList
//
//  Created by ANDROMEDA on 7/14/16.
//  Copyright © 2016 infancyit. All rights reserved.
//

import UIKit
import QuartzCore

class StrikeThroughText: UILabel {
    let strikeThroughLayer: CALayer

    var strikeThrough : Bool {
        didSet {
            strikeThroughLayer.hidden = !strikeThrough
            if strikeThrough {
                resizeStrikeThrough()
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        strikeThroughLayer = CALayer()
        strikeThroughLayer.backgroundColor = UIColor.whiteColor().CGColor
        strikeThroughLayer.hidden = true
        strikeThrough = false
        
        super.init(frame: frame)
        layer.addSublayer(strikeThroughLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeStrikeThrough()
    }
    
    let kStrikeOutThickness: CGFloat = 2.0
    
    func resizeStrikeThrough() {
        if let text = text {
            let textSize = text.sizeWithAttributes([NSFontAttributeName:font])
            strikeThroughLayer.frame = CGRect(x: 0, y: bounds.size.height/2,
                                              width: textSize.width, height: kStrikeOutThickness)
        }
    }
}