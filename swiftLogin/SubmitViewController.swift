//
//  SubmitViewController.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/8/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AVFoundation
import Parse
import UITextView_Placeholder

class SubmitViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,AVAudioRecorderDelegate,UIActionSheetDelegate,UITextViewDelegate{

    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var PictureBtn: UIButton!
    @IBOutlet weak var cancelButtonSuperview: UIView!
    
    
    @IBOutlet weak var cameraicon: UIImageView!
//    @IBOutlet weak var recordLable: UILabel!
    
    
    @IBOutlet weak var complaintImageView: UIImageView!
    @IBOutlet weak var complaintLabel: UILabel!
    @IBOutlet weak var complaintImage : UIImageView!
    
//    @IBOutlet weak var passengerSwitch: UISwitch!
//    @IBOutlet weak var passengerLabel : UILabel!
    
    @IBOutlet var scrollview: UIScrollView!
    
    var photoData:UIImage!
    var videoUrl:NSURL!
    var soundFileURL:NSURL?
    
    
    var picker:UIImagePickerController=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    var selectIndex:Int = 0
    
    var recorder: AVAudioRecorder!
    
    var player:AVAudioPlayer!
    var meterTimer:NSTimer!

    lazy var dictComplaints =
    [ "Uses a cell phone while driving" : "usecellphone",
        "Overcharges, demands tips, or does not use E-Z Pass" : "overcharges",
        "Refuses to pick up a passenger" : "pickuppassenger",
        "Refuses a credit card" : "refusecredit",
        "Refuses passenger requests" : "refuserequest",
        "Is rude" : "driverrude",
        "Is reckless or unsafe if you were the passenger" : "recklessunsafe",
        "Is reckless or unsafe if you were not the passenger" : "recklessunsafepass",
        "Takes a long route or refuses route requests" : "routrequest",
        "Fails to display a license" : "faillicense",
        "Is dirty" : "taxidirty",
        "Has broken or missing equipment" : "brokenEquip",
        "Report other fare problems when using a credit card." : "otherproblems",
        "Above and beyond to help" : "abovehelp",
        "Courteous/Kind/Polite" : "courteous",
        "Passenger without enough funds" : "passengerfund",
        "Returned passenger's property" : "returnedproperty",
        "Reward/Tip Submission" : "reward",
        "Other" : "other"]
    
    override func viewWillAppear(animated: Bool) {
     
        complaintImage.image = nil

        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if( appdelegate.typeofcomplaint.isEmpty == false ) {
            // complaintLabel.text = appdelegate.typeofcomplaint
            if dictComplaints[appdelegate.typeofcomplaint] != nil {
                complaintImage.backgroundColor = appdelegate.typeofcomplaintColor
                complaintImage.image = UIImage(named: dictComplaints[appdelegate.typeofcomplaint]!)
                
                complaintImageView.hidden = true
                complaintLabel.hidden = true
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        // Hide keyboard
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if (appdelegate.selectedReport == 0) {
            complaintImageView.image = UIImage(named: "Compliment Icon")!
            complaintLabel.text = "Select a Compliment Category"
        } else {
            complaintImageView.image = UIImage(named: "Complaint Icon")!
            complaintLabel.text = "Select a Complaint Category"
        }
        
        picker.delegate = self
        descriptionText.delegate = self
        descriptionText.placeholder = "Enter descripton here."
        
        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        
        self.scrollview.contentSize = CGSizeMake(320,536);

        if (descriptionText.text == "") {
            textViewDidEndEditing(descriptionText)
        }
        let tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        
        // self.updatePassengerLabel()
        // Do any additional setup after loading the view.
        
        // Initialized Complaint Category
        appdelegate.typeofcomplaint = ""
    }

    func dismissKeyboard(){
        descriptionText.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = ""
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
        scrollview.setContentOffset(CGPointZero, animated: true)

    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (textView.text == ""){
            textView.text = ""
            textView.textColor = UIColor.blackColor()
            
        }
        textView.becomeFirstResponder()
        let scrollPoint: CGPoint = CGPointMake(0, textView.frame.origin.y - 10)
        scrollview.setContentOffset(scrollPoint, animated: true)

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
    
    @IBAction func clickpicture(sender: AnyObject) {
        
        self.view .endEditing(true)
        var actionSheet:UIActionSheet
        
        
        actionSheet = UIActionSheet(title: "Select Your Media", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,otherButtonTitles:"Take Video","Select Video from Gallery", "Take Photo", "Select Photo from Gallery")
        actionSheet.showInView(self.view)
        actionSheet.tag = 999
        
        
        
    }
    
//    @IBAction func passengerSwitchChanged(sender: AnyObject) {
//        self.updatePassengerLabel()
//    }
//    
//    func updatePassengerLabel() {
//        self.passengerLabel.text = self.passengerSwitch.on ? "Yes, I was the passenger" : "No, I was not the passenger"
//    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if( buttonIndex == 1){
                self.openCamera()
                
            
        } else if(buttonIndex == 2){
                self.openCamera1()
            
        }else if(buttonIndex == 3){
                self.openGallary()
        }else if(buttonIndex == 4){
            self.openGallary1()
        }
        
       
        
        
    }
    
    
    func openCamera()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            selectIndex = 0
            
            print("captureVideoPressed and camera available.")
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            imagePicker.showsCameraControls = true
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
            
        else {
            print("Camera not available.")
        }
        
    }
    
    func openCamera1()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            selectIndex = 1
            
            print("captureVideoPressed and camera available.")
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary;
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = true
            
            
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
            
        else {
            print("Camera not available.")
        }
        
    }
    
    func openGallary()
    {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            selectIndex = 2
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker, animated: true, completion: nil)
        }
       
        
        
        
        
    }
    
    func openGallary1()
    {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            selectIndex = 3
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self .presentViewController(picker, animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if (selectIndex == 0)
        {
            videoUrl = info[UIImagePickerControllerMediaURL] as! NSURL!
            self.dismissViewControllerAnimated(true, completion: {})
            
            
            self.cameraicon.image = UIImage(named: "greencamera")
            self.cancelButtonSuperview.hidden = false
            photoData = nil
        }else if (selectIndex == 1)
        {
            videoUrl = info[UIImagePickerControllerMediaURL] as! NSURL!
            self.dismissViewControllerAnimated(true, completion: {})
            
            
            self.cameraicon.image = UIImage(named: "greencamera")
            self.cancelButtonSuperview.hidden = false
            photoData = nil
        }else if (selectIndex == 2)
        {
            photoData  = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
            videoUrl = nil
            self.cameraicon.image = UIImage(named: "greencamera")
            self.cancelButtonSuperview.hidden = false
            // photoData = nil
        }else
        {
            photoData  = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
            videoUrl = nil
            self.cameraicon.image = UIImage(named: "greencamera")
            self.cancelButtonSuperview.hidden = false
        }
    }
    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
//        if (selectIndex == 0)
//        {
//            videoUrl = info[UIImagePickerControllerMediaURL] as! NSURL!
//            let pathString = videoUrl.relativePath
//            self.dismissViewControllerAnimated(true, completion: {})
//        
//            
//            self.cameraicon.image = UIImage(named: "greencamera")
//            self.cancelButtonSuperview.hidden = false
//            photoData = nil
//        }else if (selectIndex == 1)
//        {
//            videoUrl = info[UIImagePickerControllerMediaURL] as! NSURL!
//            let pathString = videoUrl.relativePath
//            self.dismissViewControllerAnimated(true, completion: {})
//            
//            
//            self.cameraicon.image = UIImage(named: "greencamera")
//            self.cancelButtonSuperview.hidden = false
//            photoData = nil
//        }else if (selectIndex == 2)
//        {
//            photoData  = info[UIImagePickerControllerOriginalImage] as! UIImage
//            self.dismissViewControllerAnimated(true, completion: nil)
//            
//            
//            videoUrl = nil
//            self.cameraicon.image = UIImage(named: "greencamera")
//            self.cancelButtonSuperview.hidden = false
//            photoData = nil
//        }else
//        {
//            photoData  = info[UIImagePickerControllerOriginalImage] as! UIImage
//            self.dismissViewControllerAnimated(true, completion: nil)
//            
//            
//            videoUrl = nil
//            self.cameraicon.image = UIImage(named: "greencamera")
//            self.cancelButtonSuperview.hidden = false
//        }
//    }
    
    
    
    @IBAction func clickaudio(sender: AnyObject) {
        
        self.view .endEditing(true)
        
        if recorder == nil {
            print("recording. recorder nil")
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.recording {
            self.stop()
            
        } else {
            print("recording")
            //            recorder.record()
            recordWithPermission(false)
        }

        
    }
    
    @IBAction func clickCancelButton(sender:AnyObject) {
        self.cancelButtonSuperview.hidden = true
        self.cameraicon.image = UIImage(named: "greycamera")
        let appdelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.photoData = nil
        appdelegate.videoData = nil
        
        self.photoData = nil
        self.videoUrl = nil
    }
    
    
    @IBAction func clickComplaintButton(sender: UIButton) {
        
        print("clickComplaintButton")
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appdelegate.reportDescription = self.descriptionText.text
        appdelegate.photoData = self.photoData
        appdelegate.videoData = self.videoUrl
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        
        if (appdelegate.selectedReport == 0) { // Compliment category
            
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("complimentdetail")
            let navController = UINavigationController(rootViewController: destViewController)
            navController.navigationBar.hidden = true
            presentViewController(navController, animated: true, completion: nil)
            //self.navigationController?.pushViewController(destViewController, animated: true)
        } else {
            
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("complaintdetail")
            let navController = UINavigationController(rootViewController: destViewController)
            navController.navigationBar.hidden = true
            presentViewController(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func clicknext(sender:AnyObject)
    {
        var appdelegate : AppDelegate
        appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Check complaint string
        if (self.descriptionText.text.isEmpty)
        {
            let alertview:UIAlertView = UIAlertView(title: "Just when we were so close to the end", message: "Please write description so we know what happened", delegate: nil, cancelButtonTitle: "OK")
            alertview.show()
            return
        }
        // Check complaint category
        if (appdelegate.typeofcomplaint.isEmpty) {
            let alertview:UIAlertView = UIAlertView(title: "Just when we were so close to the end", message: "Please select complaint category so we know what happened", delegate: nil, cancelButtonTitle: "OK")
            alertview.show()
            return
        }
        
        if (recorder != nil)
        {
            if recorder != nil && recorder.recording {
                self.stop()
                
            }
        }
        
        
        appdelegate.reportDescription = self.descriptionText.text
        appdelegate.photoData = self.photoData
        appdelegate.videoData = self.videoUrl
        // appdelegate.audioData = self.soundFileURL
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        
        var destViewController : UIViewController
        
        if appdelegate.selectedReport == 0 || (appdelegate.selectedReport == 1 && appdelegate.passenger == false) {
            // In case of Compliment && Was not passenger
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("geolocationOneMap")  // was submit
        }
        else {
            //
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("geolocation")  // was submit
        }
        
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    func createRandomName() -> String
    {
        let uuid:String = NSUUID().UUIDString
        
        return uuid
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
    
    func updateAudioMeter(timer:NSTimer) {
        
        if recorder.recording {
//            let dFormat = "%02d"
//            let min:Int = Int(recorder.currentTime / 60)
//            let sec:Int = Int(recorder.currentTime % 60)
            //let s = "Recording...\(String(format: dFormat, min)):\(String(format: dFormat, sec)). To stop recording tap here again"
            // self.recordLable.text = s
            recorder.updateMeters()
            //var apc0 = recorder.averagePowerForChannel(0)
            //var peak0 = recorder.peakPowerForChannel(0)
        }
    }
    
    
    
    
    func stop() {
        print("stop")
        recorder.stop()
        meterTimer.invalidate()
        
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        do {
            try session.setActive(false)
        } catch let error1 as NSError {
            error = error1
            print("could not make session inactive")
            if let e = error {
                print(e.localizedDescription)
                return
            }
        }
        recorder = nil
    }
    
    
    
    func setupRecorder() {
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        print(currentFileName)
        
        var dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir: AnyObject = dirPaths[0]
        let soundFilePath = docsDir.stringByAppendingPathComponent(currentFileName)
        soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(soundFilePath) {
            // probably won't happen. want to do something about it?
            print("sound exists")
        }
        
        let recordSettings: [String: AnyObject] = [
            AVFormatIDKey: UInt(kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        var error: NSError?
        do {
            recorder = try AVAudioRecorder(URL: soundFileURL!, settings: recordSettings)
        } catch let error1 as NSError {
            error = error1
            recorder = nil
        }
        if let e = error {
            print(e.localizedDescription)
        } else {
            recorder.delegate = self
            recorder.meteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        }
    }
    
    func recordWithPermission(setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                        target:self,
                        selector:"updateAudioMeter:",
                        userInfo:nil,
                        repeats:true)
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error1 as NSError {
            error = error1
            print("could not set session category")
            if let e = error {
                print(e.localizedDescription)
            }
        }
        do {
            try session.setActive(true)
        } catch let error1 as NSError {
            error = error1
            print("could not make session active")
            if let e = error {
                print(e.localizedDescription)
            }
        }
    }
    
    func setSessionPlayAndRecord() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error1 as NSError {
            error = error1
            print("could not set session category")
            if let e = error {
                print(e.localizedDescription)
            }
        }
        do {
            try session.setActive(true)
        } catch let error1 as NSError {
            error = error1
            print("could not make session active")
            if let e = error {
                print(e.localizedDescription)
            }
        }
    }
    
    func deleteAllRecordings() {
        let docsDir =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let fileManager = NSFileManager.defaultManager()
        var error: NSError?
        let files = (try! fileManager.contentsOfDirectoryAtPath(docsDir)) 
        if let e = error {
            print(e.localizedDescription)
        }
        var recordings = files.filter( { (name: String) -> Bool in
            return name.hasSuffix("m4a")
        })
        for var i = 0; i < recordings.count; i++ {
            let path = docsDir + "/" + recordings[i]
            
            print("removing \(path)")
            do {
                try fileManager.removeItemAtPath(path)
            } catch let error1 as NSError {
                error = error1
                NSLog("could not remove \(path)")
            }
            if let e = error {
                print(e.localizedDescription)
            }
        }
    }
    
    func askForNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"background:",
            name:UIApplicationWillResignActiveNotification,
            object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"foreground:",
            name:UIApplicationWillEnterForegroundNotification,
            object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"routeChange:",
            name:AVAudioSessionRouteChangeNotification,
            object:nil)
    }
    
    func background(notification:NSNotification) {
        print("background")
    }
    
    func foreground(notification:NSNotification) {
        print("foreground")
    }
    
    
    func routeChange(notification:NSNotification) {
        
        
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder,
        successfully flag: Bool) {
            print("finished recording \(flag)")
            
            
            // self.recordLable.text = "Recording saved. \nTo retake, click here again"
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder,
        error: NSError?) {
            print("\(error?.localizedDescription)")
    }

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
