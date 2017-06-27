//
//  ConfirmationViewController.swift
//  Reported
//
//  Created by Alexander on 11/11/15.
//  Copyright © 2015 Joshua Weitzman. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var leftLabels: [UILabel]!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var licMedLabel: UILabel!
    @IBOutlet weak var typeOfCarLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var picOrVidLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var pickupLockLabel: UILabel!
    @IBOutlet weak var dropoffLocLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var boroughLabel: UILabel!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var aptLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViewController()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        
        updateUserInfo()
    }
    
    private func prepareViewController() {
        
        editButton.frame = CGRect(x: 7, y: 451, width: view.frame.width - 14, height: 50)
        scrollView.frame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: view.frame.width - 2 * scrollView.frame.origin.x, height: scrollView.frame.height)
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        var offsetX: CGFloat = 0
        scrollView.contentSize = CGSize(width: 320, height: 615)
        if screenWidth == 414 {
            offsetX = -95
            scrollView.contentSize = CGSize(width: 320, height: 400)
        } else if screenWidth == 375 {
            offsetX = -55
            scrollView.contentSize = CGSize(width: 320, height: 500)
        }
        
        for label in leftLabels {
            label.frame.origin = CGPoint(x: offsetX, y: label.frame.origin.y)
            print(label.frame.origin)
        }
        
        editButton.layer.borderWidth = 2
        editButton.layer.borderColor = UIColor.blackColor().CGColor

        
        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if (appdelegate.selectedReport == 0) {
            reportLabel.text = "Compliment"
        } else {
            reportLabel.text = "Complaint"
        }
        licMedLabel.text = appdelegate.medallionNo
        typeOfCarLabel.text = appdelegate.colorOfTaxi
        descriptionLabel.text = appdelegate.reportDescription != "" ? appdelegate.reportDescription : "No"
        picOrVidLabel.text = appdelegate.photoData != nil ? "Photo" : appdelegate.videoData != nil ? "Video" : "No"
        categoryLabel.text = appdelegate.typeofcomplaint
        pickupLockLabel.text = NSString(format: "(%@; %@)", appdelegate.latitude, appdelegate.longitude) as String
        dropoffLocLabel.text = NSString(format: "(%@; %@)", appdelegate.latitude2, appdelegate.longitude2) as String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM hh:mm"
        timeLabel.text = dateFormatter.stringFromDate(appdelegate.timeofreport)
        
        updateUserInfo()
    }
    
    private func updateUserInfo() {
        let mUser = PFUser.currentUser()!
        firstNameLabel.text = (mUser.objectForKey("FirstName") as! String)
        lastNameLabel.text = (mUser.objectForKey("LastName") as! String)
        emailLabel.text = (mUser.objectForKey("useremail") as! String)
        phoneLabel.text = (mUser.objectForKey("Phone") as! String)
        boroughLabel.text = (mUser.objectForKey("Borough") as! String)
        buildingLabel.text = (mUser.objectForKey("Building") as! String)
        streetLabel.text = (mUser.objectForKey("StreetName") as! String)
        aptLabel.text = (mUser.objectForKey("Apt") as! String)
    }
    
//    override func viewWillLayoutSubviews() {
//        
//        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let height = stringHeightForWidth(appdelegate.typeofcomplaint as NSString, width: categoryLabel.bounds.width, font: categoryLabel.font)
//        
//        // FIXME:- remove???
//        if height >= 20 {
//            categoryLabel.numberOfLines = 2
//            categoryLabel.frame = CGRectMake(categoryLabel.frame.origin.x, CGRectGetMidY(categoryLabel.frame) - height / 2, categoryLabel.frame.width, height)
//        }
//    }
    
    @IBAction func editButtonPressed(sender: UIButton) {
        let profileUser = storyboard!.instantiateViewControllerWithIdentifier("myprofile")
        navigationController?.pushViewController(profileUser, animated: true)
        //         presentViewController(profileUser, animated: true, completion: nil)
    }
    
    
    @IBAction func clickBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func clickSubmit(sender: UIBarButtonItem) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        SVProgressHUD.showWithStatus("Loading", maskType: .Black)
        
        let object_submission = PFObject(className: "submission")
        object_submission.setObject(appdelegate.medallionNo, forKey: "medallionNo")
        
        object_submission.setObject(appdelegate.latitude, forKey: "latitude")
        object_submission.setObject(appdelegate.longitude, forKey: "longitude")
        object_submission.setObject(appdelegate.latitude2, forKey: "latitude2")
        object_submission.setObject(appdelegate.longitude2, forKey: "longitude2")
        
        object_submission.setObject(appdelegate.timeofreport, forKey: "timeofreport")
        object_submission.setObject(appdelegate.selectedReport, forKey: "selectedReport")
        object_submission.setObject(Int(0), forKey: "status")
        object_submission.setObject(appdelegate.typeofcomplaint, forKey: "typeofcomplaint")
        object_submission.setObject(appdelegate.reportDescription, forKey: "reportDescription")
        object_submission.setObject(appdelegate.passenger, forKey: "passenger")
        object_submission.setObject(appdelegate.colorOfTaxi, forKey: "colorTaxi")
        object_submission.setObject("N/A until submitted to 311", forKey: "reqnumber")
        
        
        let mUser = PFUser.currentUser()
        object_submission.setObject(mUser!.objectForKey("FirstName")!, forKey: "FirstName")
        object_submission.setObject(mUser!.objectForKey("LastName")!, forKey: "LastName")
        object_submission.setObject(mUser!.objectForKey("Phone")!, forKey: "Phone")
        object_submission.setObject(mUser!.objectForKey("Borough")!, forKey: "Borough")
        object_submission.setObject(mUser!.objectForKey("Building")!, forKey: "Building")
        object_submission.setObject(mUser!.objectForKey("Apt")!, forKey: "Apt")
        object_submission.setObject(mUser!.objectForKey("testify")!, forKey: "testify")
        object_submission.setObject(mUser!.objectForKey("StreetName")!, forKey: "StreetName")
        object_submission.setObject(mUser!.objectForKey("useremail")!, forKey: "Username")
        
        object_submission.setObject(mUser!, forKey: "user")
        
        if (appdelegate.photoData != nil)
        {
            let resizeImage:UIImage = self.RBResizeImage(appdelegate.photoData!, targetSize: CGSizeMake(640, 960))
            
            let imageFile:PFFile = PFFile(name: "image.jpg", data: UIImageJPEGRepresentation(resizeImage, 1)!)!
            
            object_submission.setObject(imageFile, forKey: "photoData")
            
        }
        
        if (appdelegate.videoData != nil)
        {
            
            let data1: NSData? = NSData(contentsOfURL: appdelegate.videoData!)
            
            if (data1?.length > 10485760)
            {
                let alertview:UIAlertView = UIAlertView(title: "Size limit error", message: "Sorry, video files must be less than 10Mb. Please load any larger files onto Youtube or Dropbox and paste the URL into the report text box", delegate: nil, cancelButtonTitle: "OK")
                alertview.show()
                SVProgressHUD.dismiss()
                return
            }
            
            let videofile:PFFile = PFFile(name: "video.mov", data:data1!)!
            
            object_submission.setObject(videofile, forKey: "videoData")
        }
        
        if (appdelegate.audioData != nil)
        {
            
            let data1: NSData? = NSData(contentsOfURL: appdelegate.audioData!)
            
            let audiofile:PFFile = PFFile(name: "audio.m4a", data:data1!)!
            
            if (data1?.length > 10485760)
            {
                let alertview:UIAlertView = UIAlertView(title: "I guess size does matter", message: "Sorry, audio files must be less than 10Mb", delegate: nil, cancelButtonTitle: "OK")
                alertview.show()
                SVProgressHUD.dismiss()
                return
            }
            
            object_submission.setObject(audiofile, forKey: "audioData")
            
        }
        
        object_submission.saveInBackgroundWithBlock { (success: Bool, error:  NSError?) -> Void in
            SVProgressHUD.dismiss()
            appdelegate.photoData = nil
            appdelegate.videoData = nil
            appdelegate.audioData = nil
            if (success)
            {
                let alertview:UIAlertView = UIAlertView(title: "Thank You", message: "Your information has been submitted to Reported. It may take up to 24 hours for your complaint to get submitted to 311.", delegate: nil, cancelButtonTitle: "OK")
                alertview.show()
                
                var destViewController : UIViewController
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                
                destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("mycomplaints")
                
                
                var appdelegate : AppDelegate
                
                appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appdelegate.window?.rootViewController = UINavigationController(rootViewController: destViewController);
                
            }else
            {
                let alertview:UIAlertView = UIAlertView(title: "Just when we were so close to the end", message: "Your data has failed to go up to the cloud. Please check your internet connection and try again.", delegate: nil, cancelButtonTitle: "OK")
                alertview.show()
            }
        }
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    func stringHeightForWidth(string : NSString, width : CGFloat, font : UIFont) -> CGFloat {
        
        let context = NSStringDrawingContext()
        let labelSize = CGSizeMake(width, CGFloat.max)
        let r = string.boundingRectWithSize(labelSize, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: context)
        
        return r.size.height
    }
}
