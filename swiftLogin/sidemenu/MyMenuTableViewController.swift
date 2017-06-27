//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController {

    var arrayofTitle : NSArray = ["My Reports", "311 Data", "My Profile", "FAQ", "Feedback", "Share"]
    var arrayofIcon : NSArray = ["mycompliant.png", "graph.png", "myprofile.png", "faq.png", "feedback.png", "share.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.blackColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        var appdelegate : AppDelegate
        
        appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: appdelegate.selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrayofTitle.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.blackColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
            
            
        }
        
        cell!.textLabel?.text = arrayofTitle.objectAtIndex(indexPath.row) as! NSString as String
        
        cell!.imageView?.image = UIImage(named: arrayofIcon.objectAtIndex(indexPath.row) as! String)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        var appdelegate : AppDelegate
        
        appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appdelegate.selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("mycomplaints") 
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("statistics")
            break
        case 2:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("myprofile") 
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("faq") 
            break
        case 4:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("feedback") 
            break
        case 5:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("share") 
            break
            
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("mycomplaints") 
            break
        }
//        sideMenuController()?.setContentViewController(destViewController)
        dismissViewControllerAnimated(true, completion: nil)
        
        appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.initprofile = 1;
        
        let navbar :UINavigationController = UINavigationController(rootViewController: destViewController)
        
        
        navbar.navigationBar.tintColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        
        
        appdelegate.window?.rootViewController = navbar;

        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
