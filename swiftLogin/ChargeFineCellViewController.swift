//
//  ReportMainTableCell.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/8/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit
import MapKit


typealias TapOnNumberOfComplaints = () -> Void

class ChargeFineCellViewController: UITableViewCell{
    
    
    var lbltitle: UILabel = UILabel()
    var lblcountofcomplaints: UILabel = UILabel()
    var lblpercents: UILabel = UILabel()
    var imageViewCode : UIImageView = UIImageView(frame: CGRectZero)
    
    var tapOnNumberOfComplaints : TapOnNumberOfComplaints?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews()
    {
        self.clipsToBounds = true
        
        let screenwidth = UIScreen.mainScreen().bounds.size.width
        
        self.lbltitle.frame = CGRectMake(8, 12, 280, 21)
        self.lbltitle.font = UIFont(name: "GothamRounded-Medium", size: 15)
        
        self.lblcountofcomplaints.frame = CGRectMake(29, 35, 130, 21)
        self.lblcountofcomplaints.font = UIFont(name: "GothamRounded-Book", size: 12)
        self.lblpercents.frame = CGRectMake(screenwidth/2+20, 35, 130, 21)
        self.lblpercents.font = UIFont(name: "GothamRounded-Book", size: 12)
        
        self.imageViewCode.frame = CGRectMake(10, 68, 301, 50)
        self.imageViewCode.backgroundColor = UIColor(red: 130.0/255.0, green: 187.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
        var center : CGPoint = self.imageViewCode.center
        center.x = UIScreen.mainScreen().bounds.size.width/2.0
        self.imageViewCode.center = center
        
        self.contentView.addSubview(self.lbltitle)
        self.contentView.addSubview(lblcountofcomplaints)
        self.contentView.addSubview(lblpercents)
        self.contentView.addSubview(self.imageViewCode)
        
        
        let imgright = UIImageView(image: UIImage(named: "blueright"))
        imgright.frame = CGRectMake(screenwidth-25, 22, 15, 22)
        self.contentView.addSubview(imgright)
        
        let imgredalert = UIImageView(image: UIImage(named: "redalert"))
        imgredalert.frame = CGRectMake(8, 39, 13, 13)
        self.contentView.addSubview(imgredalert)
        
        let imggreenalert = UIImageView(image: UIImage(named: "greenalert"))
        imggreenalert.frame = CGRectMake(screenwidth/2, 39, 13, 13)
        self.contentView.addSubview(imggreenalert)
        
        self.backgroundColor = UIColor(white: 232/255, alpha: 1)
        self.contentView.backgroundColor = UIColor(white: 232/255, alpha: 1)
    }
    
}
