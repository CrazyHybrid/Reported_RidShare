//
//  DriverLicenseViewController.swift
//  Reported
//
//  Created by Joshua Weitzman on 1/8/15.
//  Copyright (c) 2015 Joshua Weitzman. All rights reserved.
//

import UIKit


typealias ValidationTaxiNumberClosure = (String) -> Bool

class DriverLicenseViewController: UIViewController {
    
    private var yellowTaxiButtonTag : Int = 10
    private var greenTaxiButtonTag : Int = 20
    private var blackTaxiButtonTag : Int = 30
    
    struct TaxiColors {
        static let GreenTaxi = "Green"
        static let YellowTaxi = "Yellow"
        static let BlackTaxi = "Black"
    }
    
    struct TaxiNumberRegexpStrings {
        static let GreenTaxiNumberRegexpString = "^[A-Za-z]{2}\\d{3}$"
        static let YellowTaxiNumberRegexpString = "(^\\d[A-Za-z]\\d\\d$)|(^\\d[A-Za-z]{2}\\d{3}$)"
        static let BlackTaxiNumberRegexpString = "^T\\d{5}C$"
    }
    
    struct TaxiNumberPlaceholders {
        static let GreenTaxiNumberRegexpString = "i.e AA123"
        static let YellowTaxiNumberRegexpString = "i.e 1E23 or 5BV360"
        static let BlackTaxiNumberRegexpString = "i.e T646345C"
    }
    
    private var taxiNumberRegexpString : String = ""
    
    @IBOutlet var medallionText: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var taxiButtons : Array<UIButton>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 199.0/255.0, blue: 26.0/255.0, alpha: 1.0)
        
        self.medallionText.enabled = false

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
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("submit") // was geolocation
        
        func goNextStep() {
            
            self.view.endEditing(true)
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appdelegate.medallionNo = self.medallionText.text!
            self.navigationController?.pushViewController(destViewController, animated: true)
        }
        
        if (self.medallionText.text!.isEmpty)
        {
            let alertview:UIAlertView = UIAlertView(title: "Houston, we have a problem", message: "Please input medallion number, cab license or driver's license to continue.", delegate: nil, cancelButtonTitle: "OK")
            alertview.show()
            
            return
        }
        
        let regex : NSRegularExpression? = try? NSRegularExpression(pattern: self.taxiNumberRegexpString, options: [])
        let match : Bool = regex?.matchesInString(self.medallionText.text!, options: [], range: NSMakeRange(0, self.medallionText.text!.characters.count)).count == 1
        
        if (!match) {
//            var alertview:UIAlertView = UIAlertView(title: "Houston, we have a problem", message: "Please input correct medallion number, cab license or driver's license to continue.", delegate: nil, cancelButtonTitle: "OK")
//            alertview.show()
            
            let alertController = UIAlertController(title: "Houston, we have a problem", message: "Your medallion number, cab license or driver's license does not match the pattern. Do you want to re-enter or continue?", preferredStyle: UIAlertControllerStyle.Alert)
            let reEnterAction = UIAlertAction(title: "Re-enter", style: .Default, handler: { (alert) -> Void in
                print("re-enter")
            })
            let continueAction = UIAlertAction(title: "Continue", style: .Default, handler: { (alert) -> Void in
                print("continue")
                goNextStep()
            })
            alertController.addAction(reEnterAction)
            alertController.addAction(continueAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        goNextStep()
    }
    
    @IBAction func clickimage(sender: AnyObject) {
        self.medallionText.enabled = true
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let taxiColorButton : UIButton = sender as! UIButton
        switch (taxiColorButton.tag) {
        case yellowTaxiButtonTag:
            appdelegate.colorOfTaxi = TaxiColors.YellowTaxi
            self.taxiNumberRegexpString = TaxiNumberRegexpStrings.YellowTaxiNumberRegexpString
            self.medallionText.placeholder = TaxiNumberPlaceholders.YellowTaxiNumberRegexpString
            break
        case greenTaxiButtonTag:
            appdelegate.colorOfTaxi = TaxiColors.GreenTaxi
            self.taxiNumberRegexpString = TaxiNumberRegexpStrings.GreenTaxiNumberRegexpString
            self.medallionText.placeholder = TaxiNumberPlaceholders.GreenTaxiNumberRegexpString
            break
        case blackTaxiButtonTag:
            appdelegate.colorOfTaxi = TaxiColors.BlackTaxi
            self.taxiNumberRegexpString = TaxiNumberRegexpStrings.BlackTaxiNumberRegexpString
            self.medallionText.placeholder = TaxiNumberPlaceholders.BlackTaxiNumberRegexpString
            break
        default:
            break
        }
        
        self.selectTaxiButton(taxiColorButton)
    }
    
    
    func selectTaxiButton(button : UIButton) {
        for taxiButton in self.taxiButtons {
            (taxiButton as UIButton).enabled = true
        }
        button.enabled = false
    }

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
