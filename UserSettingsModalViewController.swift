//
//  UserSettingsModalViewController.swift
//  
//
//  Created by Taras Pasichnyk on 6/16/15.
//
//
import UIKit

class UserSettingsModalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var barButtonSave: UIBarButtonItem!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let pickerData = ["English", "Ukrainian"]
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.setObject(pickerData[row], forKey: "appLanguage")
        
        if let name = defaults.stringForKey("appLanguage")
        {
            println(name)
        }
    }
    
    @IBAction func saveUserSettings(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
