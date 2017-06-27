//
//  ComplaintTypeViewController.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/8/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit

class ComplaintTypeViewController: UIViewController {

    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var lblcount: UILabel!
    
    @IBOutlet var lblpercent: UILabel!
    
    @IBOutlet var btnTitle: UIButton!
    
    @IBOutlet var content: UITableView!
    
    var categorytype: String!
    
    
    var chargeResult:NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.content.registerClass(ChargeFineCellViewController.self, forCellReuseIdentifier: "mycell")
        
        
        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        
        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
        let path = NSBundle.mainBundle().pathForResource("categories", ofType: "json")
        
        
        let jsonData = try? NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
        let jsonResult: NSMutableArray = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)) as! NSMutableArray
        
        for tempdic in jsonResult {
            
            
            let typestring :String = tempdic.objectForKey("category") as! String
         
            if typestring == categorytype{
                
                
                switch (typestring)
                {
                case "Uses a cell phone while driving":
//                    btntype.setImage(UIImage(named: "usecellphone.png"), forState: UIControlState.Normal)
                    
                    btnTitle.setTitle("Uses a cell phone while driving", forState: .Normal)
                 
                    
                    break
                case "Overcharges, demands tips, or does not use E-Z Pass":
//                    btntype.setImage(UIImage(named: "overcharges.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Overcharges, demands tips, or does not use E-Z Pass", forState: .Normal)
                    
                    break
                case "Refuses to pick up a passenger":
//                    btntype.setImage(UIImage(named: "pickuppassenger.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Refuses to pick up a passenger", forState: .Normal)
                    break
                case "Refuses a credit card":
//                    btntype.setImage(UIImage(named: "refusecredit.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Refuses a credit card", forState: .Normal)
                    
                    break
                case "Refuses passenger requests":
//                    btntype.setImage(UIImage(named: "refuserequest.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Refuses passenger requests", forState: .Normal)
                    
                    break
                case "Is rude":
//                    btntype.setImage(UIImage(named: "driverrude.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Is rude", forState: .Normal)
                    
                    break
                case "Is reckless or unsafe if you were the passenger":
//                    btntype.setImage(UIImage(named: "recklessunsafe.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Is reckless or unsafe for passengers", forState: .Normal)
                    
                    break
                case "Is reckless or unsafe if you were not the passenger":
//                    btntype.setImage(UIImage(named: "recklessunsafepass.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Is reckless or unsafe for non passengers", forState: .Normal)
                    
                    break
                case "Takes a long route or refuses route requests":
//                    btntype.setImage(UIImage(named: "routrequest.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Takes a long route...", forState: .Normal)
                    break
                case "Fails to display a license":
//                    btntype.setImage(UIImage(named: "faillicense.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Fails to display a license", forState: .Normal)
                    break
                case "Is dirty":
//                    btntype.setImage(UIImage(named: "taxidirty.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Taxi is dirty", forState: .Normal)
                    break
                case "Has broken or missing equipment":
//                    btntype.setImage(UIImage(named: "taxibroken.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Has broken or missing equipment", forState: .Normal)
                    break
                case "Report other fare problems when using a credit card.":
//                    btntype.setImage(UIImage(named: "otherproblems.png"), forState: UIControlState.Normal)
                    btnTitle.setTitle("Other fare problems when using a credit card", forState: .Normal)
                    break
                    
                default:
                    break
                }

                
                
                
                
                let percent : String = tempdic.objectForKey("percent") as! String
                lblpercent.text = percent + "% of 2014 consumer complaints"
                
                let count : String = tempdic.objectForKey("count") as! String
                lblcount.text = count + " violations in 2014"
                
                let arraycharge : NSMutableArray = tempdic.objectForKey("charge_codes") as! NSMutableArray
                
                
                
                
                let path = NSBundle.mainBundle().pathForResource("charges", ofType: "json")
                
                
                
                let jsonData = try? NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
                let jsonResult1  = (try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)) as! NSMutableArray
                
                
                

                
                
                for var index = 0; index < arraycharge.count; ++index {
                    
                    
                    let item1 : String = arraycharge.objectAtIndex(index) as! String
                    
                    
                    
                    
                    for var index1 = 0; index1 < jsonResult1.count-1; ++index1 {
                        
                        let object: NSMutableDictionary = jsonResult1.objectAtIndex(index1)
                            as! NSMutableDictionary
                        
                        
                        let chargecode = object.objectForKey("charge_code") as? String
                        
                        
                        if chargecode == item1 {
                            chargeResult.addObject(object)
                        }
                        
                    }
                    
                    
                }
                
             
                
                content.reloadData()
//                txtchargecodes.text = totalitem
                
                
            }
        }
        
        
        
        
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
    
    
    
    /* table view delegate
    
    */
    

    //func
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.chargeResult.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ChargeFineCellViewController = tableView.dequeueReusableCellWithIdentifier("mycell") as! ChargeFineCellViewController
        
        
        let object: NSMutableDictionary = self.chargeResult.objectAtIndex(indexPath.row)
            as! NSMutableDictionary
        
        //Cell Header right Below here
        cell.lbltitle.text = object.objectForKey("charge_code") as? String
        
        let violations : NSMutableDictionary = object.objectForKey("violations") as! NSMutableDictionary
        
        var countofcomplaints : String = violations.objectForKey("consumer_complaints_2014") as! String
        
        
        countofcomplaints  = String(format: "%@ Complaints", countofcomplaints)
        
        
        cell.lblcountofcomplaints.text = countofcomplaints
        
        
        var percentcomplaints : String = violations.objectForKey("consumer_complaints_percentage_2014") as! String
        
        
        percentcomplaints  = String(format: "%@%% of Complaints", percentcomplaints)
        
        
        cell.lblpercents.text = percentcomplaints
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let object: NSMutableDictionary = self.chargeResult.objectAtIndex(indexPath.row)
            as! NSMutableDictionary
        
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : FraudTheftViewController
        
        
        
        
        destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("fraud") as! FraudTheftViewController
        destViewController.dataCharge = object
        
        
        self.navigationController?.pushViewController(destViewController, animated: true)
        
        
        
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 67
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    

    

}
