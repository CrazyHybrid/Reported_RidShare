//
//  ChargeHeaderView.swift
//  Reported
//
//  Created by Joshua Weitzman on 4/18/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit

class ChargeHeaderView: UIView {

    @IBOutlet weak var chargeTypeLabel : UILabel!
    
    @IBOutlet weak var countOfComplaints : UILabel!
    
    @IBOutlet weak var blueView : UIView!
    
    @IBOutlet weak var chargeIcon : UIImageView!
    
    
    class func loadViewFormNib() -> ChargeHeaderView{
        let view : ChargeHeaderView = NSBundle.mainBundle().loadNibNamed("ChargeHeaderView", owner: self, options: nil).first as! ChargeHeaderView
        return view
    }

    
        override func awakeFromNib() {
        blueView.layer.borderWidth = 1
        blueView.layer.borderColor = UIColor.blackColor().CGColor
            
    }

}
