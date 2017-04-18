//
//  ViewController.swift
//  Mix_Master
//
//  Created by Brent Wishart on 4/17/17.
//  Copyright © 2017 Brent Wishart. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //Sampler
    let s:MIDISampler = MIDISampler()

    //Outlets
    @IBOutlet weak var picker_view: UIPickerView!

    //Actions
    @IBAction func touch(_ sender: UIButton) {
        let instrument = self.picker_view.selectedRow(inComponent: 0)
        let button:String = sender.currentTitle!
        let note:Int = s.notes[button]!
        
        self.s.start(note: UInt8(note), instrument: UInt8(instrument))
    }
    
    //Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.s.instruments.count
        default:
            return 0
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return self.s.instruments[row]
        default:
            return "error"
        }
    }

    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

