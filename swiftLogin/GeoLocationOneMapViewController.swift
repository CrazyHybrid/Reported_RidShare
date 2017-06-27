//
//  GeoLocationViewController.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/20/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD


class GeoLocationOneMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate ,UITextFieldDelegate,NSURLConnectionDelegate{
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var Map: MKMapView!
    
    var anotation = MKPointAnnotation()
    @IBOutlet var srcScrollView: UIScrollView!
    lazy var data = NSMutableData()
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var locationText: UITextField!
    
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var dateView: UIView!
    
    private let ANNOTATION_TAG = 1243
    private let ANNOTATION_ANCHORPOINT = CGPointMake(0.25, 0.88)
    var activeTextField:UITextField!
    var locationManager = CLLocationManager()
    var locationFixAchieved : Bool = false
    var coordinatemap :CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        Map.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            locationManager.requestAlwaysAuthorization()
        case .OrderedAscending:
            print("iOS < 8.0")
        }
        dateView.hidden = true
        
        locationManager.startUpdatingLocation()
        
        let barBackgroundImage = UIImage(named: "Top Navigation Bar")!.resizableImageWithCapInsets(UIEdgeInsets(), resizingMode: .Stretch)
        navBar.setBackgroundImage(barBackgroundImage, forBarMetrics: .Default)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy, h:mm a" // superset of OP's format
        let str = dateFormatter.stringFromDate(NSDate())
        
        self.timeText.text = str

        locationText.delegate = self
        
        activeTextField = locationText
        srcScrollView.contentSize = CGSize(width: 320, height: 510)
        
        doneButton.hidden = true
        self.dateView.frame.origin = CGPoint(x: 0, y: 314)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            coordinatemap = locations.last
            
            let center = CLLocationCoordinate2D(latitude: coordinatemap.coordinate.latitude, longitude: coordinatemap.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            anotation.coordinate = self.Map.region.center
            anotation.title = "Taxi location"
            //           anotation.subtitle = "This is the location !!!"
            
            self.Map.addAnnotation(anotation)
            self.Map.setRegion(region, animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView( mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if mapView.isEqual(Map) {
            let region : MKCoordinateRegion = mapView.region
            anotation.coordinate = region.center
            let annotView : MKAnnotationView? = mapView.viewForAnnotation(anotation);
            if (annotView != nil) {
                self.Map.removeAnnotation(anotation)
                
                annotView?.layer.anchorPoint = ANNOTATION_ANCHORPOINT
                annotView?.center = mapView.convertCoordinate(anotation.coordinate, toPointToView: mapView)
                
                annotView?.tag = ANNOTATION_TAG
                self.Map.addSubview(annotView!)
            }
        }
    }
    
    func mapView( mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let annotView : UIView? = mapView.viewWithTag(ANNOTATION_TAG)
        annotView?.removeFromSuperview()
        
        let region : MKCoordinateRegion = mapView.region
        if mapView.isEqual(Map) {
            anotation.coordinate = region.center
            self.Map.addAnnotation(anotation)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        let annotView : MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "CustomPinAnnotationView")
        
        annotView.pinColor = MKPinAnnotationColor.Red
        
        return annotView
        
        //        let reuseId = "test"
        //
        //
        //        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        //
        //        if anView == nil {
        //
        //            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        //
        //
        //
        //            anView.canShowCallout = true
        //            anView.draggable = true
        //
        //        }
        //
        //        else {
        //    //we are re-using a view, update its annotation reference...
        //
        //            anView.canShowCallout = true
        //            anView.draggable = true
        //
        //            anView.annotation = annotation
        //
        //        }
        //
        //
        //        return anView
        
    }
    
    // MARK: -
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        //        let info: NSDictionary = sender.userInfo!
        //        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        //        let keyboardSize: CGSize = value.CGRectValue().size
        //        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        //        srcScrollView.contentInset = contentInsets
        //        srcScrollView.scrollIndicatorInsets = contentInsets
        //
        //        var scframe = srcScrollView.frame;
        //        scframe.size.height -= keyboardSize.height
        //
        //        // If active text field is hidden by keyboard, scroll it so it's visible
        //        // Your app might not need or want this behavior.
        //        var aRect: CGRect = self.view.frame
        //        aRect.size.height -= keyboardSize.height
        //        let activeTextFieldRect: CGRect? = activeTextField?.frame
        //        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        //
        //        srcScrollView.scrollRectToVisible(scframe, animated:true)
        //        scframe.size.height += 50;
        //        srcScrollView.frame = scframe;
        
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        //        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        //        srcScrollView.contentInset = contentInsets
        //        srcScrollView.scrollIndicatorInsets = contentInsets
        //        srcScrollView.frame = self.view.frame
        let locationTogeo:String = activeTextField.text!
        //
        //        var cfLocationTogeo : CFString! = CFURLCreateStringByAddingPercentEscapes(
        //            nil,
        //            locationTogeo,
        //            nil,
        //            "!*'();:@&=+$,/?%#[]",
        //            CFStringBuiltInEncodings.UTF8.rawValue
        //        )
        
        
        
        let urlPath : String = String(format: "http://maps.google.com/maps/api/geocode/json?address=%@,nyc&components=country:US", locationTogeo)
        
        //bug fixed by krisen 2016.2.29
        let urlNew:String = urlPath.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url: NSURL = NSURL(string: urlNew)!
        
        
        //let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
        SVProgressHUD.showInfoWithStatus("Search location", maskType: SVProgressHUDMaskType.Black)
        
        
        
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        //        srcScrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //        activeTextField = nil
        //        srcScrollView.scrollEnabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        
        // throwing an error on the line below (can't figure out where the error message is)
        let jsonResult: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        print(jsonResult)
        
        self.data = NSMutableData()
        
        // 4
        let jsonresults: NSArray! = jsonResult["results"] as! NSArray
        let stateresult = jsonResult["status"] as! String
        if (stateresult == "OK")
        {
            let addressresult: NSDictionary! = jsonresults.objectAtIndex(0) as! NSDictionary
            let geometrydata: NSDictionary! = addressresult["geometry"] as! NSDictionary
            let locationdata: NSDictionary! = geometrydata["location"] as! NSDictionary
            
            let doubleLatitude : Double = locationdata["lat"] as! Double
            let doubleLongitude : Double = locationdata["lng"] as! Double
            
            
            
            
            
            let center = CLLocationCoordinate2D(latitude: doubleLatitude, longitude: doubleLongitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            
            
            if activeTextField.isEqual(locationText) {
                self.anotation.coordinate = center
                self.anotation.title = "Taxi location"
                //           self.anotation.subtitle = "This is the location !!!"
                
                self.Map.addAnnotation(self.anotation)
                self.Map.setRegion(region, animated: true)
            }
            SVProgressHUD.dismiss()
            
            
        }else
        {
            SVProgressHUD.dismiss()
            let alertview:UIAlertView = UIAlertView(title: "We are not in Kansas anymore", message: "Please input a valid address", delegate: nil, cancelButtonTitle: "OK")
            alertview.show()
            return
            
        }
        
        
        
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
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clickDatePicker(sender: AnyObject) {
        dateView.hidden = false
        doneButton.hidden = false
        self.view.endEditing(true)
        
    }
    
    @IBAction func clickDone(sender: AnyObject) {
        dateView.hidden = true
        doneButton.hidden = true
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy, h:mm a" // superset of OP's format
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        timeText.text = strDate
        
        
        
    }
    
    
    @IBAction func clicknext(sender:AnyObject)
    {
        var appdelegate : AppDelegate
        
        appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.longitude = String(format: "%f", self.Map.region.center.longitude)
        appdelegate.latitude = String(format: "%f", self.Map.region.center.latitude)
        
        appdelegate.timeofreport = NSDate()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        
        //        if (appdelegate.selectedReport == 0) {
        //            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("complimentdetail") 
        //        } else {
        //            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("complaintdetail")
        //        }
        destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("confirmation")
        self.navigationController?.pushViewController(destViewController, animated: true)
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
