//
//  PickerViewController.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/14/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

protocol PickerViewControllerDelegate {
    func updateSeconds(seconds: Double)
}

class PickerViewController: UIViewController {
    
    // MARK: Outlets and vars
    
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var delegate: PickerViewControllerDelegate!
    
    var seconds: Double! = 0.0
    
    var segmentOptions: [Double] = [600, 900, 1200, 1500]
    var segmentTitles = ["10 min", "15 min", "20 min", "25 min"]
    
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.setDate(setDateFromSeconds(seconds), animated: true)
        
        for (index, title) in enumerate(segmentTitles) {
            segment.setTitle(title, forSegmentAtIndex: index)
        }
    }
    
    func setDateFromSeconds(seconds: Double) -> (NSDate) {
        let intSeconds = Int(seconds)
        let minutes = (intSeconds / 60) % 60
        let hours = intSeconds / 3600
        let dateString = NSString(format: "%0.2d:%0.2d", hours, minutes)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.dateFromString(dateString as String) as NSDate!
    }
    
    
    // MARK: Actions
    
    @IBAction func pickerChanged(sender: UIDatePicker) {
        segment.selectedSegmentIndex = -1
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        let controlIndex = sender.selectedSegmentIndex
        picker.setDate(setDateFromSeconds(segmentOptions[controlIndex]), animated: true)
    }
    
    @IBAction func setButton(sender: UIButton) {
        delegate?.updateSeconds(picker.countDownDuration)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func noReminderButton(sender: UIButton) {
        delegate?.updateSeconds(0.0)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backgroundTap(sender: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
