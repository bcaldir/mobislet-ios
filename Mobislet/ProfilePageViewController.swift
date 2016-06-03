//
//  RightSliderViewController.swift
//  Mobislet
//
//  Created by Bedirhan Caldir on 09/04/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

enum Direction { case In, Out }
protocol Dimmable { }
extension Dimmable where Self: UIViewController {
    func dim(direction: Direction, color: UIColor = UIColor.blackColor(), alpha: CGFloat = 0.0, speed: Double = 0.0) {
        switch direction {
        case .In:
            // Create and add a dim view
            let dimView = UIView(frame: view.frame)
            dimView.backgroundColor = color
            dimView.alpha = 0.0
            view.addSubview(dimView)
            // Deal with Auto Layout
            dimView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            // Animate alpha (the actual "dimming" effect)
            UIView.animateWithDuration(speed) { () -> Void in
                dimView.alpha = alpha
            }
        case .Out:
            UIView.animateWithDuration(speed, animations: { () -> Void in
                self.view.subviews.last?.alpha = alpha ?? 0
                }, completion: { (complete) -> Void in
                    self.view.subviews.last?.removeFromSuperview()
            })
        }
    }
}

extension UIButton {
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10)
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return CGRectContainsPoint(hitFrame, point)
    }
}

class ProfilePageViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate, Dimmable {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthdayField: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameEditButton: UIButton!
    @IBOutlet weak var birthdayEditButton: UIButton!
    @IBOutlet weak var phoneEditButton: UIButton!
    @IBOutlet weak var genderEditButton: UIButton!
    
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    var oldText: String = ""
    var anyFieldChanged: Bool = false
    var activeField: UITextField?
    var currentKeyboardHeight: CGFloat = 0
    
    var facebookID: String = "0"
    var loginView: FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Save", style: .Plain , target: self, action: #selector(ProfilePageViewController.uploadInformation(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        // Do any additional setup after loading the view.
        nameField.delegate = self
        phoneField.delegate = self
        genderField.delegate = self
        emailField.delegate = self
        
        // facebook information retrieval
        createFacebookButton()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
            returnUserData()
        } else {
            loginView.readPermissions = ["public_profile", "email", "user_friends", "user_birthday"]
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfilePageViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfilePageViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if (activeField != nil) {
                if (!CGRectContainsPoint(self.view.frame, CGPoint(x: activeField!.frame.origin.x, y: activeField!.frame.origin.y + activeField!.frame.height + keyboardSize.height))) {
                    currentKeyboardHeight = activeField!.frame.origin.y + keyboardSize.height - self.view.frame.height + activeField!.frame.height + 10
                    self.view.frame.origin.y -= currentKeyboardHeight
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            self.view.frame.origin.y += currentKeyboardHeight
            currentKeyboardHeight = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "datePickerSegue"){
            let theDestination = segue.destinationViewController as! DatePickerViewController
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            theDestination.datePicked = dateFormatter.dateFromString(birthdayField.text!)
            dim(.In, alpha: dimLevel, speed: dimSpeed)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var txtAfterUpdate:NSString = textField.text! as NSString
        txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
        
        if (textField == phoneField){
            if ((txtAfterUpdate as String).characters.count < 3 || txtAfterUpdate.substringWithRange(NSRange(location: 0,length: 3)) != "+90" || (txtAfterUpdate as String).characters.count > 13) { return false }
            let newCharacters = NSCharacterSet(charactersInString: string)
            return NSCharacterSet.decimalDigitCharacterSet().isSupersetOfSet(newCharacters)
        }
        
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil){
            // Process error
            print("\(error)")
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            if result.grantedPermissions.contains("email") {
                // Do work
            }
            self.returnUserData()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,gender,birthday"])  // picture.width(480).height(480)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
                let userGender : NSString = result.valueForKey("gender") as! NSString
                print("User Gender is: \(userGender)")
                let userBirthday : NSString = result.valueForKey("birthday") as! NSString
                print("User Birthday is: \(userBirthday)")
                
                self.nameField.text = userName as String
                self.emailField.text = userEmail as String
                self.genderField.text = userGender as String
                let day   = (userBirthday as NSString).substringWithRange(NSRange(location: 3, length: 2)) as String
                let month = (userBirthday as NSString).substringWithRange(NSRange(location: 0, length: 2)) as String
                let year  = (userBirthday as NSString).substringWithRange(NSRange(location: 6, length: 4)) as String
                self.birthdayField.text = day + "/" + month + "/" + year
                self.facebookID = result.valueForKey("id") as! String
                
                let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(result.valueForKey("id") as! NSString)/picture?type=large")
                if let data = NSData(contentsOfURL: facebookProfileUrl!) {
                    self.profilePicture.image = UIImage(data: data)
                }
            }
        })
    }
    
    func uploadInformation(sender: UIBarButtonItem){
        if (anyFieldChanged){
            print("changed")
            
            let params = [
                "name": NSString(data:self.nameField.text!.dataUsingEncoding(NSUTF8StringEncoding)!, encoding:NSUTF8StringEncoding) as! String,
                "email": self.emailField.text! as String,
                "gender": self.genderField.text! as String,
                "birthday": self.birthdayField.text! as String,
                "phoneNumber": self.phoneField.text! as String,
                "facebookID": self.facebookID,
                "latitude": 0,
                "longitude": 0,
                "altitude": 0,
            ]
            
            DataService.sharedInstance.sendAlamofireRequest(.POST, urlString: "\(DataService.USER_SERVICE_URL)\(DataService.USER_ADD_POST_URL)", parameters: params as? [String : NSObject]) { (result, err) -> Void in
                
                if let error = err {
                    
                    
                    let alert = SCLAlertView()
                    
                    alert.showInfo("Uyarı", subTitle: error.description, closeButtonTitle: "Kapat")
                    alert.dismissBlock = { () -> Void in
                        
                    }
                    
                    
                } else if let dict = result {
                    print("done!!!!!")
                }
            }
            
            /*var jsonObject = Dictionary<String, String>()
            jsonObject["name"]        = self.nameField.text! as String
            jsonObject["email"]       = self.emailField.text! as String
            jsonObject["gender"]      = self.genderField.text! as String
            jsonObject["birthday"]    = self.birthdayField.text! as String
            jsonObject["facebookID"]  = self.facebookID
            jsonObject["phoneNumber"] = self.phoneField.text! as String
            jsonObject["latitude"]    = "333"
            jsonObject["longitude"]   = "111"
            jsonObject["altitude"]    = "123"
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:8080/JerseyMobislet/rest/service/user/addUser")!)
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField : "Content-Type")
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonObject, options: [])
            
            Alamofire.request(request)
                .responseString { response in
                    switch response.result {
                    case .Failure(let error):
                        print(error)
                    case .Success(let responseObject):
                        print(responseObject)
                    }
            }*/
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func createFacebookButton(){
        self.view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: loginView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: loginView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -20))
        loginView.delegate = self
    }
    
    @IBAction func editNameField(sender: AnyObject) {
        focusTextField(nameField)
    }
    
    @IBAction func editPhoneField(sender: AnyObject) {
        focusTextField(phoneField)
    }
    
    @IBAction func editGenderField(sender: AnyObject) {
        focusTextField(genderField)
    }
    
    func focusTextField(textField: UITextField){
        if (activeField != nil) {
            activeField!.enabled = false
            activeField!.layer.borderWidth = CGFloat(Float(0.0))
        }
        activeField = textField
        oldText = textField.text!
        textField.enabled = true
        textField.layer.borderColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha:1).CGColor
        textField.layer.borderWidth = CGFloat(Float(1.0))
        textField.layer.cornerRadius = CGFloat(Float(5.0))
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        activeField = nil
        textField.resignFirstResponder()
        textField.enabled = false
        textField.layer.borderWidth = CGFloat(Float(0.0))
        
        if (textField.text! != oldText) { anyFieldChanged = true }
        
        return true
    }
    
    @IBAction func closeBirtdayPicker(segue: UIStoryboardSegue) {
        let datePickerVC = segue.sourceViewController as! DatePickerViewController
        datePickerVC.saveDatePicked()
        dim(.Out, speed: dimSpeed)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let oldBirthday = birthdayField.text
        birthdayField.text = dateFormatter.stringFromDate(datePickerVC.datePicked)
        if oldBirthday != birthdayField.text { anyFieldChanged = true }
    }
    
}
