//
//  ChargeFinesViewController.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/8/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit

class ChargeFinesViewController: UIViewController {

    
    var transitionOperator = TransitionOperator()
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet var container:UITableView!
    
    var jsonResult:NSMutableArray = []
    var jsonCategoriesResult:NSMutableDictionary = NSMutableDictionary()

    var submitionArray: NSArray! = NSArray ()
    
    var jsonResultComplaints : NSMutableDictionary = NSMutableDictionary()
    var showingJsonResultComplaints : NSMutableDictionary = NSMutableDictionary()
    var countOfResultComplaints : NSMutableDictionary = NSMutableDictionary()
    var chargesCodes: NSArray? = NSArray ()
    
    var selectedRow : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.hidden = true
        
        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
        self.container.registerClass(ChargeFineCellViewController.self, forCellReuseIdentifier: "mycell")
        
        let path = NSBundle.mainBundle().pathForResource("charges", ofType: "json")
        
        

        let jsonData = try? NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
        jsonResult  = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)) as! NSMutableArray
        
       
        
        
        
        for var index = 0; index < jsonResult.count-1; ++index {
            for var index1 = index+1; index1 < jsonResult.count; ++index1 {
                
            
                let item1 : NSMutableDictionary = jsonResult.objectAtIndex(index) as! NSMutableDictionary
                let violations : NSMutableDictionary = item1.objectForKey("violations") as! NSMutableDictionary
                let countofcomplaints : String = violations.objectForKey("total_violations") as! String
                let nCount = Int(countofcomplaints)
                
                ///
                
                let item2 : NSMutableDictionary = jsonResult.objectAtIndex(index1) as! NSMutableDictionary
                let violations2 : NSMutableDictionary = item2.objectForKey("violations") as! NSMutableDictionary
                let countofcomplaints2 : String = violations2.objectForKey("total_violations") as! String
                let nCount2 = Int(countofcomplaints2)
                
                if nCount < nCount2{
                    jsonResult.exchangeObjectAtIndex(index, withObjectAtIndex: index1)
                }
                
            }
            
        }
        
        

        for var index = 0; index < jsonResult.count; ++index {
            let item : NSMutableDictionary = jsonResult.objectAtIndex(index) as! NSMutableDictionary
            
            let titlechargecode : String = item.objectForKey("tlc_category") as! String
            
            var items : NSMutableArray? = jsonResultComplaints.objectForKey(titlechargecode) as? NSMutableArray
            
            if items == nil {
                items = NSMutableArray()
                jsonResultComplaints.setObject(items!, forKey: titlechargecode)
                showingJsonResultComplaints.setObject([], forKey: titlechargecode)
                
                let violations : NSMutableDictionary = item.objectForKey("violations") as! NSMutableDictionary
                let countofcomplaints : String = violations.objectForKey("total_violations") as! String
                
                var count : Int? = self.countOfResultComplaints.objectForKey(titlechargecode) as? Int
                if count == nil {
                    count = Int(countofcomplaints)
                }
                else {
                    count = count! + Int(countofcomplaints)!
                }
                self.countOfResultComplaints.setObject(count!, forKey: titlechargecode)
            }
            
            items?.addObject(item)
        }
        
        self.chargesCodes = self.jsonResultComplaints.allKeys
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toggleSideMenu(sender: AnyObject) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var toViewController : UITableViewController
        
        toViewController = mainStoryboard.instantiateViewControllerWithIdentifier("sidebar") as! UITableViewController
        
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator
        self .presentViewController(toViewController, animated: true) { () -> Void in
            
            
        }
        
    }
    
    
    
    /* table view delegate
    
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.chargesCodes!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items : NSArray = self.showingJsonResultComplaints.objectForKey(self.chargesCodes!.objectAtIndex(section)) as! NSArray
//        if self.jsonResult.count > 10{
//            return 10
//        }
//        return self.jsonResult.count
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        
        let cell:ChargeFineCellViewController = tableView.dequeueReusableCellWithIdentifier("mycell") as! ChargeFineCellViewController
        
        cell.clipsToBounds = true
        
        
        let object: NSMutableDictionary = objectWithIndexPath(indexPath)
        
        //Cell Title on Line Below
        cell.lbltitle.text = object.objectForKey("charge_code") as? String
        
        let violations : NSMutableDictionary = object.objectForKey("violations") as! NSMutableDictionary
        
        var countofcomplaints : String = violations.objectForKey("total_violations") as! String
        
        
        countofcomplaints  = String(format: "%@ Complaints", countofcomplaints)
        
        
        cell.lblcountofcomplaints.text = countofcomplaints
        
        
        var percentcomplaints : String = violations.objectForKey("complaints_percentage_2013") as! String
        
        
        percentcomplaints  = String(format: "%@%% of Complaints", percentcomplaints)
        
        
        cell.lblpercents.text = percentcomplaints
        
        cell.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        cell.tapOnNumberOfComplaints = {() -> Void in
            if self.selectedRow == indexPath.row {
                self.rollUpCellWithIndexPath(indexPath)
            }
            else {
                self.selectedRow = indexPath.row
                tableView.beginUpdates()
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
                
//        if self.selectedRow == indexPath.row {
//            var titlechargecode : String = object.objectForKey("tlc_category") as! String
//            cell.imageViewCode.image = self.imageWithTypeOfComplaint(titlechargecode)
//        }
//        else {
//            cell.imageViewCode.image = nil
//        }
        cell.imageViewCode.image = nil
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let object: NSMutableDictionary = objectWithIndexPath(indexPath)
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : FraudTheftViewController
        
        
        
        
        destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("fraud") as! FraudTheftViewController
        destViewController.dataCharge = object
        
        
        self.navigationController?.pushViewController(destViewController, animated: true)
        
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.selectedRow == indexPath.row {
            return 67 + 60
        }
        return 67
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var titlechargecode : String = self.chargesCodes!.objectAtIndex(section) as! String
//        var headerView : UIImageView = UIImageView(image: self.imageWithTypeOfComplaint(titlechargecode))
//        headerView.contentMode = .Center
//        headerView.backgroundColor = UIColor(red: 130.0/255.0, green: 187.0/255.0, blue: 227.0/255.0, alpha: 1.0)
//        headerView.userInteractionEnabled = true
//        headerView.tag = section
//        
//        var topSeparator : UIView = UIView(frame: CGRectMake(0, 0, 600, 0.5))
//        var bottomSeparator : UIView = UIView(frame: CGRectMake(0, 49.5, 600, 0.5))
//        
//        topSeparator.backgroundColor = UIColor.blackColor()
//        bottomSeparator.backgroundColor = UIColor.blackColor()
//        
//        headerView.addSubview(topSeparator)
//        headerView.addSubview(bottomSeparator)
//        
//        var tapRecognizer = UITapGestureRecognizer(target: self, action: "tapOnHeaderViewAction:")
//        headerView.addGestureRecognizer(tapRecognizer)
        
        let headerView : ChargeHeaderView = ChargeHeaderView.loadViewFormNib()
        
        let titlechargecode : String = self.chargesCodes!.objectAtIndex(section) as! String
        headerView.tag = section
        headerView.chargeTypeLabel.text = titlechargecode
        headerView.chargeIcon.image = self.imageWithTypeOfComplaint(titlechargecode)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tapOnHeaderViewAction:")
        headerView.addGestureRecognizer(tapRecognizer)
        
        let countofcomplaints : String = String(format: "%i Complaints", (self.countOfResultComplaints.objectForKey(titlechargecode) as! Int))
        headerView.countOfComplaints.text = countofcomplaints
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func rollUpCellWithIndexPath(indexPath : NSIndexPath) {
        
        let cell : ChargeFineCellViewController? = self.container.cellForRowAtIndexPath(indexPath) as? ChargeFineCellViewController
        cell?.imageViewCode.image = nil
        
        self.selectedRow = -1;
        self.container.beginUpdates()
        self.container.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        self.container.endUpdates()
    }

    
    func objectWithIndexPath(indexPath : NSIndexPath) -> NSMutableDictionary {
        let items : NSArray! = showingJsonResultComplaints.objectForKey(self.chargesCodes!.objectAtIndex(indexPath.section)) as? NSArray
        
        let object: NSMutableDictionary = items!.objectAtIndex(indexPath.row)
            as! NSMutableDictionary
        
        return object
    }
    
    ///MARK: -
    
    func imageWithTypeOfComplaint(typeOfComplaint : String) -> UIImage? {
        
        var image : UIImage!
        
        switch (typeOfComplaint)
        {
        case "Uses a cell phone while driving":
            image = UIImage(named: "usedCellIcon")
            break
        case "Overcharges, demands tips, or does not use E-Z Pass":
            image = UIImage(named: "overchargesIcon")
            break
        case "Refuses to pick up a passenger":
            image = UIImage(named: "refusesPickUpIcon")
            break
        case "Refuses a credit card":
            image = UIImage(named: "creditCardIcon")
            break
        case "Refuses passenger requests":
            image = UIImage(named: "refusesRequestsIcon")
            break
        case "Is rude":
            image = UIImage(named: "driverRudeIcon")
            break
        case "Is reckless or unsafe if you were the passenger":
            image = UIImage(named: "recklessOrUnsafeIcon")
            break
        case "Is reckless or unsafe if you were not the passenger":
            image = UIImage(named: "recklessOrUnsafeIcon")
            break
        case "Takes a long route or refuses route requests":
            image = UIImage(named: "longerRouteIcon")
            break
        case "Fails to display a license":
            image = UIImage(named: "failsLicenseIcon")
            break
        case "Is dirty":
            image = UIImage(named: "taxiDirtyIcon")
            break
        case "Has broken or missing equipment":
            image = UIImage(named: "brokenLinkIcon")
            break
        case "Report other fare problems when using a credit card.":
            image = UIImage(named: "otherccproblems")
            break
            
        default:
            break
        }
        
        return image
    }

    
    ///MARK: -
    
    func tapOnHeaderViewAction(sender : UITapGestureRecognizer) {
        let section : Int? = sender.view?.tag
        let titlechargecode : String = self.chargesCodes!.objectAtIndex(section!) as! String
        
        let items : NSArray = jsonResultComplaints.objectForKey(titlechargecode)! as! NSArray
        
        
        var indexPaths = [NSIndexPath]()
        
        for var row = 0; row < items.count; ++row {
            indexPaths.append(NSIndexPath(forRow: row, inSection: section!))
            // indexPaths.addObject(NSIndexPath(forRow: row, inSection: section!))
        }

        if (self.showingJsonResultComplaints.objectForKey(titlechargecode) as! NSArray).count == 0 {
            self.showingJsonResultComplaints.setObject(items, forKey: titlechargecode)
            self.container.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        }
        else {
            self.showingJsonResultComplaints.setObject([], forKey: titlechargecode)
            self.container.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
