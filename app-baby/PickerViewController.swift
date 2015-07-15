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
    
    var delegate:PickerViewControllerDelegate!
    
    var seconds: Double! = 0.0
    
    var segmentOptions: [Double] = [600, 900, 1200, 1500]
    var segmentTitles = ["10 min", "15 min", "20 min", "25 min"]
    
    
    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.countDownDuration = seconds
        
        for (index, title) in enumerate(segmentTitles) {
            segment.setTitle(title, forSegmentAtIndex: index)
        }
    }
    
    // MARK: Actions

    @IBAction func pickerChanged(sender: UIDatePicker) {
        segment.selectedSegmentIndex = -1
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        let controlIndex = sender.selectedSegmentIndex
        picker.countDownDuration = segmentOptions[controlIndex]
    }
    
    @IBAction func setButton(sender: UIButton) {
        delegate?.updateSeconds(picker.countDownDuration)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func noReminderButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backgroundTap(sender: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
