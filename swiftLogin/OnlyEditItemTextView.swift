//
//  OnlyEditItemTextView.swift
//  Reported
//
//  Created by Joshua Weitzman on 4/18/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit

class OnlyEditItemTextView: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == "define:" {
            return false
        }
        else {
            return super.canPerformAction(action, withSender:sender)
        }
    }

    
}
