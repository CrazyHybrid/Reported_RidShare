//
//  FaqViewController.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/8/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class FaqViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    var faqArray : NSArray = []
    var titlefont:UIFont = UIFont(name: "GothamRounded-Medium", size: 16)!;
    var descfont:UIFont = UIFont(name: "GothamRounded-Book", size: 14)!;
    
    
    var tmplabel:UILabel!
    
    var tmplabel1:UILabel!
    
    var heighttitleArray = NSMutableArray()
    var heightdescArray = NSMutableArray()
    
    
    var transitionOperator = TransitionOperator()
    
    @IBOutlet var container:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenwidth = UIScreen.mainScreen().bounds.size.width
    
        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
        
        tmplabel = UILabel(frame: CGRectMake(8, 0, screenwidth-28, CGFloat.max))
        tmplabel1 = UILabel(frame: CGRectMake(8, 0, screenwidth-28, CGFloat.max))
        
        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.hidden = true
        
         self.container.registerClass(FaqTableCell.self, forCellReuseIdentifier: "mycell")
        
        let query :PFQuery = PFQuery(className: "faq")
        query.orderByDescending("createdAt")
        SVProgressHUD .showWithStatus("Loading...", maskType: SVProgressHUDMaskType.Black)
        query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
            
            SVProgressHUD.dismiss()
            if (error != nil) {
                NSLog("error " + error!.localizedDescription)
            }
            else {
                NSLog("objects %@", objects! as NSArray)
                self.faqArray = objects!
                
                for tempdic  in objects! {
                    
                    
                    let faqdescription :String = tempdic.objectForKey("faqdescription") as! String
                    
                    let title : String = tempdic.objectForKey("title") as! String
                    
                    let titlewidth = self.heightForView(title, font: self.titlefont, width: 288) as CGFloat
                    
                    let descwidth = self.heightForView1(faqdescription, font: self.descfont, width: 288) as CGFloat
                    
                    
                    self.heighttitleArray.addObject(titlewidth)
                    self.heightdescArray.addObject(descwidth)
                }
                
                
                
                
                self.container.reloadData()
                
            }
        })

        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FaqTableCell = tableView.dequeueReusableCellWithIdentifier("mycell") as! FaqTableCell
        
      
        
        let screenwidth = UIScreen.mainScreen().bounds.size.width
        
        
        
        let object: PFObject = self.faqArray.objectAtIndex(indexPath.section)
            as! PFObject
        
        let faqdescription = object.objectForKey("faqdescription") as? String
        let title = object.objectForKey("title") as? String
        
        
                
        let titlewidth = heighttitleArray.objectAtIndex(indexPath.section) as! CGFloat
        
        cell.lbltitle.frame = CGRectMake(8, 8, screenwidth-28, titlewidth)
        cell.lbltitle.text = title
        cell.lineview.frame = CGRectMake(0, titlewidth+17, screenwidth, 2)
        
        
        let descwidth = heightdescArray.objectAtIndex(indexPath.section) as! CGFloat
        
        
        cell.lbldescription.frame = CGRectMake(8, 27+titlewidth, screenwidth-28, descwidth)
        cell.lbldescription.text = faqdescription
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        cell.lbltitle.sizeToFit()
        cell.lbldescription.sizeToFit()
        return cell
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        tmplabel.numberOfLines = 0
        tmplabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tmplabel.font = titlefont
        tmplabel.text = text
        
        tmplabel.sizeToFit()
        return tmplabel.frame.height
    }
    
    func heightForView1(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        tmplabel1.numberOfLines = 0
        tmplabel1.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tmplabel1.font = descfont
        tmplabel1.text = text
        
        tmplabel1.sizeToFit()
        return tmplabel1.frame.height
    }
    
   
   
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
     
        
        
        
        
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let titlewidth = heighttitleArray.objectAtIndex(indexPath.section) as! CGFloat
        
        let descwidth = heightdescArray.objectAtIndex(indexPath.section) as! CGFloat
        
        
        
        return titlewidth+descwidth+30
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return self.faqArray.count
    
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
