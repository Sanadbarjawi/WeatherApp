//
//  ConfigurationViewController.swift
//  WeatherApp
//
//  Created by Sanad  on 6/22/18.
//  Copyright © 2018 Sanad LTD. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var chooseCityLbl: UILabel!
    @IBOutlet weak var nextBtn: DesignableButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var cities=["Jordan","London","USA","UAE"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func nextBtnPressed(_ sender: Any) {
        
    }
}

extension ConfigurationViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "AvenirNext-Bold", size: 14)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = cities[row]
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
    
}
