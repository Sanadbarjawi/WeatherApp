//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sanad  on 6/22/18.
//  Copyright © 2018 Sanad LTD. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class WeatherViewController: UIViewController {

//MARK: - IB-Outlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherConditionImgView: UIImageView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var conditionLbl: UILabel!
    
//MARK: - Custom Variables
    
    let weatherDataModel = WeatherDataModel()
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    var CountryID:Int = 0
    let url = "http://api.openweathermap.org/data/2.5/weather?units=metric"

//MARK: - App Life-cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherData()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
//MARK: - WeatherData API Method
    func getWeatherData() {
        activityIndicator.startAnimating()
        let parameters : [String : Any] = ["id" : CountryID, "appid" : APP_ID]

        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLbl.text = "Connection Issues"
            }
            self.activityIndicator.stopAnimating()
        }
        
    }
//MARK: - Passing the Model the API Data Method
    func updateWeatherData(json : JSON) {
        
        let tempResult = json["main"]["temp"].doubleValue
        
        weatherDataModel.temperature = Int(tempResult)
        
        weatherDataModel.conditionStatement = json["weather"][0]["description"].stringValue
        
        weatherDataModel.city = json["name"].stringValue
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        
        updateUIWithWeatherData()
    }
    
//MARK: - Updating UI Method
    func updateUIWithWeatherData() {
        conditionLbl.text = weatherDataModel.conditionStatement
        cityLbl.text = weatherDataModel.city
        tempLbl.text = "\(weatherDataModel.temperature)°"
        weatherConditionImgView.image = UIImage(named: weatherDataModel.weatherIconName)
        
    }
}
