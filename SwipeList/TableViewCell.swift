//
//  TableViewCell.swift
//  SwipeList
//
//  Created by ANDROMEDA on 7/14/16.
//  Copyright © 2016 infancyit. All rights reserved.
//

import UIKit
import QuartzCore

protocol TableViewCellDelegate {
    func itemDeleted(item: ToDoItem)
}

class TableViewCell: UITableViewCell {
    
    let gradientLayer = CAGradientLayer()
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false, completeOnDragRelease = false
    let label: StrikeThroughText
    var itemCompleteLayer = CALayer()
    var delegate: TableViewCellDelegate?
    var todoitem: ToDoItem?
    let kLabelLeftMargin: CGFloat = 15.0
    
    //to do item observer
    var item: ToDoItem? {
        didSet {
            label.text = item!.text
            label.strikeThrough = item!.completed
            itemCompleteLayer.hidden = !label.strikeThrough
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        //custom label implementation
        label = StrikeThroughText(frame: CGRect.null)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(16)
        label.backgroundColor = UIColor.clearColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //adding custom label
        addSubview(label)
        selectionStyle = .None
        
        // gradient layer
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).CGColor as CGColorRef
        let color2 = UIColor(white: 1.0, alpha: 0.1).CGColor as CGColorRef
        let color3 = UIColor.clearColor().CGColor as CGColorRef
        let color4 = UIColor(white: 0.0, alpha: 0.1).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, atIndex: 0)
        
        // green colored completion layer
        itemCompleteLayer = CALayer(layer: layer)
        itemCompleteLayer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0).CGColor
        itemCompleteLayer.hidden = true
        layer.insertSublayer(itemCompleteLayer, atIndex: 0)
        
        // pan recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(TableViewCell.handlePan(_:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        itemCompleteLayer.frame = bounds
        label.frame = CGRect(x: kLabelLeftMargin, y: 0, width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height)
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            originalCenter = center
        }
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
        }
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if deleteOnDragRelease {
                if delegate != nil && todoitem != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.itemDeleted(todoitem!)
                }
            } else if completeOnDragRelease {
                if todoitem != nil {
                    todoitem!.completed = true
                }
                label.strikeThrough = true
                itemCompleteLayer.hidden = false
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            } else {
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
        }
    }
    
    //gesture recognizer
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }

}