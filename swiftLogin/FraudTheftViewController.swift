//
//  FraudTheftViewController.swift
//  swiftLogin
//
//  Created by Fang on 1/20/15.
//  Copyright (c) 2015 iOS-Blog. All rights reserved.
//

import UIKit

class FraudTheftViewController: UIViewController {

    
    var dataCharge : NSMutableDictionary = NSMutableDictionary()
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var lblchargecode:UILabel!
    
    @IBOutlet var txtdescription:UILabel!
    
    @IBOutlet var lblpenalty:UILabel!
    @IBOutlet var imgpenalty:UIImageView!
    
    @IBOutlet var lblpoints:UILabel!
    @IBOutlet var imgpoint:UIImageView!
    
    @IBOutlet var txtdetail:UITextView!
    
    
    @IBOutlet var lblconsumer:UILabel!
    
    
    @IBOutlet var topview:UIView!
    
    
    @IBOutlet var thirdview:UIView!
    
    
    @IBOutlet var scrollview:UIScrollView!
    
    @IBOutlet var titlebtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        
        let titlechargecode : String = dataCharge.objectForKey("charge_code") as! String
        
        let chargecode : String = dataCharge.objectForKey("tlc_category") as! String
        lblchargecode.text = chargecode
        lblchargecode.numberOfLines = 0
        lblchargecode.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lblchargecode.sizeToFit()
        
        
        var tmpframe: CGRect = txtdescription.frame
        tmpframe.origin.y = lblchargecode.frame.origin.y + lblchargecode.frame.height + 5
        
        txtdescription.frame = tmpframe
        
        titlebtn.setTitle(titlechargecode, forState: .Normal)
        
        let chargeofdescription : String = dataCharge.objectForKey("description") as! String
        txtdescription.text = chargeofdescription
        txtdescription.numberOfLines = 0
        txtdescription.lineBreakMode = NSLineBreakMode.ByWordWrapping
        txtdescription.sizeToFit()

        let penalty : String = dataCharge.objectForKey("penalty") as! String
        lblpenalty.text = penalty
        lblpenalty.sizeToFit()
        
        
        tmpframe = imgpenalty.frame
        tmpframe.origin.y = txtdescription.frame.origin.y + txtdescription.frame.height + 8
        
        imgpenalty.frame = tmpframe
        
        tmpframe = lblpenalty.frame
        tmpframe.origin.y = txtdescription.frame.origin.y + txtdescription.frame.height + 8
        lblpenalty.frame = tmpframe
        
        var heightofpenalty = lblpenalty.frame.height
        
        if heightofpenalty < 20
        {
            heightofpenalty = 20
        }
        tmpframe = imgpoint.frame
        tmpframe.origin.y = lblpenalty.frame.origin.y + heightofpenalty + 8
        imgpoint.frame = tmpframe
        
        
        tmpframe = lblpoints.frame
        tmpframe.origin.y = lblpenalty.frame.origin.y + heightofpenalty + 6
        lblpoints.frame = tmpframe
        
        
        tmpframe = topview.frame
        tmpframe.size.height = imgpoint.frame.origin.y + imgpoint.frame.size.height+18
        topview.frame = tmpframe
        
        
        tmpframe = thirdview.frame
        tmpframe.origin.y = topview.frame.origin.y + topview.frame.size.height+10
        thirdview.frame = tmpframe
        
        
        self.scrollview.contentSize = CGSizeMake(320,thirdview.frame.origin.y + thirdview.frame.size.height+10);

        
        
      
        let points : String = dataCharge.objectForKey("points") as! String
        let pointsline = String(format: "%@ points on license", points)
        lblpoints.text = pointsline
        
        let violations : NSMutableDictionary = dataCharge.objectForKey("violations") as! NSMutableDictionary
        let consumer_2014 : String = violations.objectForKey("consumer_complaints_2014") as! String
        let consumer_2013 : String = violations.objectForKey("consumer_complaints_2013") as! String
        
        let consumer  = String(format: "%@ Consumer Complaints in 2014\n(%@ in 2013)", consumer_2014,consumer_2013)
        lblconsumer.text = consumer
        
        
        let summons : String = violations.objectForKey("consumer_complaints_percentage_pay_summons") as! String
        let trial : String = violations.objectForKey("consumer_complaints_percentage_trial") as! String
        let quilty : String = violations.objectForKey("consumer_complaints_percentage_guilty") as! String
        
         let detailconsumer  = String(format: "%@%% of drivers paid $350 Summons \n \n%@%% of complaints went to trial \n \n%@%% of drivers found guilty", summons,trial,quilty)
        
        txtdetail.text = detailconsumer
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickback(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
