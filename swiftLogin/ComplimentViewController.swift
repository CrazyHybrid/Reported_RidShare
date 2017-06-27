//
//  ComplimentViewController.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/8/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit

class ComplimentViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)

        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func clickback(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    @IBAction func clicknext(sender:AnyObject)
    {
        var appdelegate : AppDelegate
        
        appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let selectedButton :UIButton = sender as! UIButton
        
        switch (selectedButton.tag)
        {
        case 0:
            appdelegate.typeofcomplaint = "Above and beyond to help"
            break
        case 1:
            appdelegate.typeofcomplaint = "Courteous/Kind/Polite"
            break
        case 2:
            appdelegate.typeofcomplaint = "Passenger without enough funds"
            break
        case 3:
            appdelegate.typeofcomplaint = "Returned passenger's property"
            break
        case 4:
            appdelegate.typeofcomplaint = "Reward/Tip Submission"
            break
        case 5:
            appdelegate.typeofcomplaint = "Other"
            break
        default:
            break
        
        }
        
        appdelegate.typeofcomplaintColor = selectedButton.backgroundColor
        
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
//        let destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("geolocationOneMap")
//        self.navigationController?.pushViewController(destViewController, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
