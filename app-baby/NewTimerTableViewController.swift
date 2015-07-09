//
//  NewTimerTableViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/7/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

class NewTimerTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    var timer = Timer?()
    
    @IBOutlet weak var dumbText: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dumbText.delegate = self
        
        // for edit
        if let timer = timer {
            navigationItem.title = timer.beginTime
            dumbText.text = timer.beginTime
        }

        checkValidMealName()
    }
    
    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let text = dumbText.text ?? ""
        saveButton.enabled = !text.isEmpty
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveButton === sender {
            timer = Timer(beginTime: dumbText.text)
        }
    }
}
