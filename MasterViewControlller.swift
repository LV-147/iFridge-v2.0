//
//  MasterViewControlller.swift
//  iFridge
//
//  Created by apple on 03.06.15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UIViewController,UITextViewDelegate{
    
    
    
    
    var text:String = ""
    @IBOutlet var textView: UITextView!
    @IBAction func DismissKeyboard(sender: AnyObject) {
        textView.resignFirstResponder()
    }
    @IBOutlet var stepperlabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    var isAuthenticated = false
    
    
    
    var didReturnFromBackground = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title="Response"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "image.jpg")!)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("score") != nil {
            
            stepperlabel.text = userDefaults.objectForKey("score") as? String
            
        }
        if userDefaults.objectForKey("text") != nil{
            text = (userDefaults.objectForKey("text") as? String)!
        }
        self.textView.delegate = self;
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
        
        view.alpha = 0
        
        
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.textView.resignFirstResponder()
    }
    @IBAction func stepperValueChanged(sender: UIStepper) {
        stepperlabel.text = Int(sender.value).description
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(stepperlabel.text, forKey: "score")
        userDefaults.synchronize()
        
    }
    
    
    /**
    * Called when the user click on the view (outside the UITextField).
    */
    
    
    
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
        isAuthenticated = true
        view.alpha = 1.0
    }
    
    func appWillResignActive(notification : NSNotification) {
        
        view.alpha = 0
        isAuthenticated = false
        didReturnFromBackground = true
    }
    
    func appDidBecomeActive(notification : NSNotification) {
        
        if didReturnFromBackground {
            self.showLoginView()
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(false)
        self.showLoginView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showLoginView() {
        
        if !isAuthenticated {
            
            self.performSegueWithIdentifier("loginView", sender: self)
        }
    }
    
    
    func textViewDidEndEditing( textView: UITextView){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(text, forKey: "text")
        userDefaults.synchronize()
        
        
        
    }
    
    
    @IBAction func logoutAction(sender: AnyObject) {
        
        
        isAuthenticated = false
        self.performSegueWithIdentifier("loginView", sender: self)
        //    segue destinationViewController setManagedObjectContext:self.managedObjectContext
    }
    
    // MARK: - Fetched results controller
    
    
}

