//
//  LoginViewController.swift
//  iFridge
//
//  Created by apple on 04.07.15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//
import UIKit
import CoreData
import LocalAuthentication
import Security

class LoginViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    // MARK: - Set up
    let MyKeychainWrapper = KeychainWrapper()
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    var error : NSError?
    var context = LAContext()
    let MyOnePassword = OnePasswordExtension()
    var has1PasswordLogin : Bool = false
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createInfoLabel: UILabel!
    @IBOutlet weak var touchIDButton: UIButton!
    @IBOutlet weak var onepasswordSigninButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "image.jpg")!)
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        
        // 2.
        if hasLogin {
            self.loginButton.setTitle("Login", forState: UIControlState.Normal)
            self.loginButton.tag = loginButtonTag
            self.createInfoLabel.hidden = true
            self.onepasswordSigninButton.enabled = true
        } else {
            self.loginButton.setTitle("Create", forState: UIControlState.Normal)
            self.loginButton.tag = createLoginButtonTag
            self.createInfoLabel.hidden = false
            self.onepasswordSigninButton.enabled = false
        }
        
        onepasswordSigninButton.hidden = true
        var has1Password = NSUserDefaults.standardUserDefaults().boolForKey("has1PassLogin")
        
        if MyOnePassword.isAppExtensionAvailable() {
            
            onepasswordSigninButton.hidden = false
            
            if has1Password {
                onepasswordSigninButton.setImage(UIImage(named: "onepassword-button") , forState: .Normal)
            } else {
                onepasswordSigninButton.setImage(UIImage(named: "onepassword-button-green") , forState: .Normal)
            }
        }
        
        // 3.
        let storedUsername : String? = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        self.usernameTextField.text  = storedUsername
        
        
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.touchIDButton.hidden = false
        }
    }
    
    // MARK: - Action for checking username/password
    @IBAction func loginAction(sender: AnyObject) {
        
        // 1.
        if (self.usernameTextField.text == "" || self.passwordTextField.text == "") {
            var alert = UIAlertView()
            alert.title = "You must enter both a username and password!"
            alert.addButtonWithTitle("Oops!")
            alert.show()
            return;
        }
        
        // 2.
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        // 3.
        if sender.tag == createLoginButtonTag {
            
            // 4.
            let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
            if hasLoginKey == false {
                NSUserDefaults.standardUserDefaults().setValue(self.usernameTextField.text, forKey: "username")
            }
            
            // 5.
            MyKeychainWrapper.mySetObject(self.passwordTextField.text, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.loginButton.tag = loginButtonTag
            
            self.performSegueWithIdentifier("dismissLogin", sender: self)
        } else if sender.tag == loginButtonTag {
            // 6.
            if self.checkLogin(self.usernameTextField.text, password: self.passwordTextField.text) {
                self.performSegueWithIdentifier("dismissLogin", sender: self)
            } else {
                // 7.
                var alert = UIAlertView()
                alert.title = "Login Problem"
                alert.message = "Wrong username or password."
                alert.addButtonWithTitle("Foiled Again!")
                alert.show()
            }
        }
    }
    
    
    @IBAction func touchIDLoginAction(sender: AnyObject) {
        // 1.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            // 2.
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,localizedReason: "Logging in with Touch ID",
                reply: { (success : Bool, error : NSError! ) -> Void in
                    
                    // 3.
                    dispatch_async(dispatch_get_main_queue(), {
                        if success {
                            self.performSegueWithIdentifier("dismissLogin", sender: self)
                        }
                        
                        if error != nil {
                            
                            var message : NSString
                            var showAlert : Bool
                            
                            // 4.
                            switch(error.code) {
                            case LAError.AuthenticationFailed.rawValue:
                                message = "There was a problem verifying your identity."
                                showAlert = true
                                break;
                            case LAError.UserCancel.rawValue:
                                message = "You pressed cancel."
                                showAlert = true
                                break;
                            case LAError.UserFallback.rawValue:
                                message = "You pressed password."
                                showAlert = true
                                break;
                            default:
                                showAlert = true
                                message = "Touch ID may not be configured"
                                break;
                            }
                            
                            var alert = UIAlertView()
                            alert.title = "Error"
                            alert.message = message as String
                            alert.addButtonWithTitle("Darn!")
                            if showAlert {
                                alert.show()
                            }
                            
                        }
                    })
                    
            })
        } else {
            // 5.
            var alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Touch ID not available"
            alert.addButtonWithTitle("Darn!")
            alert.show()
        }
    }
    
    @IBAction func canUse1Password(sender: AnyObject) {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("has1PassLogin") != nil {
            self.findLoginFrom1Password(self)
        } else {
            self.saveLoginTo1Password(self)
        }
    }
    
    // MARK: - Login with 1Password
    @IBAction func findLoginFrom1Password(sender: AnyObject) {
        
        MyOnePassword.findLoginForURLString( "TouchMeIn.Login",
            forViewController: self,
            sender: sender,
            completion: { (loginDict : [NSObject: AnyObject]!, error : NSError!) -> Void in
                // 1.
                if loginDict == nil {
                    if (Int32)(error.code) != AppExtensionErrorCodeCancelledByUser {
                        println("Error invoking 1Password App Extension for find login: \(error)")
                    }
                    return
                }
                
                // 2.
                if NSUserDefaults.standardUserDefaults().objectForKey("username") == nil {
                    NSUserDefaults.standardUserDefaults().setValue(loginDict[AppExtensionUsernameKey],
                        forKey: "username")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                
                // 3.
                var foundUsername = loginDict["uas!rname"] as! String
                var foundPassword = loginDict["password"] as! String
                
                if self.checkLogin(foundUsername, password: foundPassword) {
                    self.performSegueWithIdentifier("dismissLogin", sender: self)
                } else {
                    var alert = UIAlertView()
                    alert.title = "Error"
                    alert.message = "The info in 1Password is incorrect"
                    alert.addButtonWithTitle("Darn!")
                    alert.show()
                }
        })
    }
    
    func checkLogin( username : String, password : String ) -> Bool {
        
        if password == MyKeychainWrapper.myObjectForKey("v_Data") as! NSString &&
            username == NSUserDefaults.standardUserDefaults().valueForKey("username") as? NSString {
                return true
        } else {
            return false
        }
    }
    
    // MARK: - Create 1Password record
    func saveLoginTo1Password(sender: AnyObject) {
        // 1.
        var newLoginDetails : NSDictionary = [
            AppExtensionTitleKey: "Touch Me In",
            AppExtensionUsernameKey: self.usernameTextField.text,
            AppExtensionPasswordKey: self.passwordTextField.text,
            AppExtensionNotesKey: "Saved with the TouchMeIn app",
            AppExtensionSectionTitleKey: "Touch Me In app",
        ]
        // 2.
        var passwordGenerationOptions : NSDictionary = [
            AppExtensionGeneratedPasswordMinLengthKey: 6,
            AppExtensionGeneratedPasswordMaxLengthKey: 10
        ]
        
        // 3.
        MyOnePassword.storeLoginForURLString("TouchMeIn.Login", loginDetails: newLoginDetails as [NSObject : AnyObject],passwordGenerationOptions: passwordGenerationOptions as [NSObject : AnyObject],
            forViewController: self, sender: sender) { (loginDict : [NSObject : AnyObject]!, error : NSError!) -> Void in
                
                // 4.
                if loginDict == nil {
                    if ((Int32)(error.code) != AppExtensionErrorCodeCancelledByUser) {
                        println("Error invoking 1Password App Extension for find login: \(error)")
                    }
                    return
                }
                
                // 5.
                var foundUsername = loginDict["username"] as! String
                var foundPassword = loginDict["password"] as! String
                
                // 6.
                if self.checkLogin(foundUsername, password: foundPassword) {
                    
                    self.performSegueWithIdentifier("dismissLogin", sender: self)
                    
                } else {
                    // 7.
                    var alert = UIAlertView()
                    alert.title = "Error"
                    alert.message = "The info in 1Password is incorrect"
                    alert.addButtonWithTitle("Darn!")
                    alert.show()
                }
                
                if NSUserDefaults.standardUserDefaults().objectForKey("username") != nil {
                    NSUserDefaults.standardUserDefaults().setValue(self.usernameTextField.text, forKey: "username")
                }
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "has1PassLogin")
                NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
}
