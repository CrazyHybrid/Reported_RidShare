//
//  ComplaintViewController.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/8/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit

class ComplaintViewController: UIViewController {

    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet weak var navBar: UINavigationBar!
    var segmentedControl: UISegmentedControl!
    
    @IBOutlet var buttons: [UIButton]!
    
    
    var complaints = [String]()
    
    lazy var dictComplaints =
    [ "usecellphone" : "Uses a cell phone while driving",
        "overcharges" : "Overcharges, demands tips, or does not use E-Z Pass",
        "pickuppassenger" : "Refuses to pick up a passenger",
        "refusecredit" : "Refuses a credit card",
        "refuserequest" : "Refuses passenger requests",
        "driverrude" : "Is rude",
        "recklessunsafe" : "Is reckless or unsafe if you were the passenger",
        "recklessunsafepass" : "Is reckless or unsafe if you were not the passenger",
        "routrequest" : "Takes a long route or refuses route requests",
        "faillicense" : "Fails to display a license",
        "taxidirty" : "Is dirty",
        "brokenEquip" : "Has broken or missing equipment",
        "otherproblems" : "Report other fare problems when using a credit card."]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        
        self.scrollview.contentSize = CGSizeMake(320,750);

        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
        let items = ["Was a Passenger", "Was NOT a Passenger"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.frame = CGRect(x: 8, y: 14 + navBar.frame.origin.y + navBar.frame.height, width: view.frame.width-16, height: 29)
        segmentedControl.addTarget(self, action: "selectedControlChanged:", forControlEvents: .ValueChanged)
        view.addSubview(segmentedControl)

        segmentedControl.selectedSegmentIndex = 0
        selectedControlChanged(self)
    }
    
    @IBAction func clickback(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectedControlChanged(sender: AnyObject) {
        print("selectedControlChanged")
        if segmentedControl.selectedSegmentIndex == 0 {
            complaints = [ "usecellphone", "overcharges", "refusecredit", "refuserequest","driverrude","recklessunsafe","routrequest","faillicense","taxidirty", "brokenEquip","otherproblems"]
            scrollview.contentSize = CGSizeMake(320,700)
        } else {
            complaints = [ "usecellphone", "pickuppassenger", "recklessunsafepass"]
            scrollview.contentSize = CGSizeMake(320,295)
        }
        reloadButtons()
    }
    
    func reloadButtons() {
        for var i = 0; i < buttons.count; i++ {
            if (i < complaints.count) {
                buttons[i].setImage(UIImage(named: complaints[i]), forState: .Normal)
                buttons[i].hidden = false
            } else {
                buttons[i].hidden = true
            }
        }
    }
    
    @IBAction func clicknext(sender:AnyObject)
    {
        
        var appdelegate : AppDelegate
        
        appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appdelegate.passenger = self.segmentedControl.selectedSegmentIndex == 0
        let selectedButton :UIButton = sender as! UIButton
        
        appdelegate.typeofcomplaint = dictComplaints[complaints[selectedButton.tag]]!
        appdelegate.typeofcomplaintColor = selectedButton.backgroundColor
//        
//        
//        let selectedButton :UIButton = sender as! UIButton
//
//        switch (selectedButton.tag)
//        {
//        case 0:
//            appdelegate.typeofcomplaint = "Uses a cell phone while driving"
//            break
//        case 1:
//            if segmentedControl.selectedSegmentIndex == 0 {
//                appdelegate.typeofcomplaint = "Overcharges, demands tips, or does not use E-Z Pass"
//            } else {
//                appdelegate.typeofcomplaint = "Refuses to pick up a passenger"
//            }
//            break
//        case 2:
//            if segmentedControl.selectedSegmentIndex == 0 {
//                appdelegate.typeofcomplaint = "Refuses a credit card"
//            } else {
//                appdelegate.typeofcomplaint = "Is reckless or unsafe if you were not the passenger"
//            }
//            break
//        case 3:
//            appdelegate.typeofcomplaint = "Refuses passenger requests"
//            break
//        case 4:
//            appdelegate.typeofcomplaint = "Is rude"
//            break
//        case 5:
//            appdelegate.typeofcomplaint = "Is reckless or unsafe if you were the passenger"
//            break
//        case 6:
//            appdelegate.typeofcomplaint = "Is reckless or unsafe if you were the passenger"
//            break
//        case 7:
//            appdelegate.typeofcomplaint = "Takes a long route or refuses route requests"
//            break
//        case 8:
//            appdelegate.typeofcomplaint = "Fails to display a license"
//            break
//        case 9:
//            appdelegate.typeofcomplaint = "Is dirty"
//            break
//        case 10:
//            appdelegate.typeofcomplaint = "Has broken or missing equipment"
//            break
//        case 11:
//            appdelegate.typeofcomplaint = "Report other fare problems when using a credit card."
//            break
//        case 12:
//            appdelegate.typeofcomplaint = "Report other fare problems when using a credit card."
//            break
//        
//        default:
//            break
//        }

        // let identifier = segmentedControl.selectedSegmentIndex == 0 ? "geolocation" : "geolocationOneMap"
        
//        if segmentedControl.selectedSegmentIndex == 1 {
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
//            let destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("geolocationOneMap")  // was submit
//            self.navigationController?.pushViewController(destViewController, animated: true)
//        }
//        else {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
