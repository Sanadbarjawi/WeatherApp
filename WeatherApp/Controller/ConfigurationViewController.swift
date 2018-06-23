//
//  ConfigurationViewController.swift
//  WeatherApp
//
//  Created by Sanad  on 6/22/18.
//  Copyright © 2018 Sanad LTD. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ConfigurationViewController: UIViewController {
    
//MARK: - IB-Outlets

    @IBOutlet weak var CountryNCityPickerView: UIPickerView!
    @IBOutlet weak var chooseCityLbl: UILabel!
    @IBOutlet weak var nextBtn: DesignableButton!
    @IBOutlet weak var backBtn: DesignableButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//MARK: - Custom Variables

    var isCountryPicked:Bool = false
    var selectedCountry = ""
    var citiesArray=[geoNamesModel]()
    var countriesArray=[CountriesDataModel]()
    var GeoID:Int?=0
    
//MARK: - App Life-cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if selectedCountry != ""{//if country is selected then update UI to the two buttons state(next and back buttons visible)
            countrySelectedUpdateUI()
        }else{//if country is NOT selected then update UI to the initial state
            initialStateUpdateUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountriesService()
    }
 
    //MARK: - GetCountries API Method
    func getCountriesService(){
       
        let url = "https://battuta.medunes.net/api/country/all/"
        let params:[String:String] = ["key":"6b0798bf9e3f5708e5ff6d0ac25f6ff2"]
        activityIndicator.startAnimating()

            Alamofire.request(url, method: .get, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    do{
                        let countries = try JSONDecoder().decode([CountriesDataModel].self, from: response.data!)
                        for country in countries {
                            self.countriesArray.append(country)
                        }
                        self.selectFirstRow()
                    }catch{
                        print(error)
                    }
                
                
                }
                else {
                    print("Error \(String(describing: response.result.error))")
                }
                self.activityIndicator.stopAnimating()
        }
    }
    
//MARK: - GetCities API Method
    //this API is a free api to get all cities for the given country parameter.
    func getCitiesService(){
        let params = ["country":selectedCountry]
        let url = "http://api.geonames.org/searchJSON?username=Sanadbarj&maxRows=1000&style=SHORT&fcode=PPLA&fcode=PPLC"
        activityIndicator.startAnimating()
        Alamofire.request(url, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                do{
                    let citiesJSON = JSON(response.data!)
                    print(citiesJSON)
                    let cities = try JSONDecoder().decode(CitiesDataModel.self, from: response.data!)
                    for city in cities.geonames{
                        self.citiesArray.append(city)
                    }
                    self.selectFirstRow()
                }catch{
                    print(error)
                }
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
            self.activityIndicator.stopAnimating()

        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        citiesArray.removeAll()
        initialStateUpdateUI()
        CountryNCityPickerView.reloadAllComponents()
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        if isCountryPicked{//if country is picked navigate to the weatherViewController passing the country ID.
            let vc = WeatherViewController(nibName: "WeatherViewController", bundle: nil)
            vc.CountryID = GeoID!
            navigationController?.pushViewController(vc, animated: true)
        }else{//if country is not picked then select country based on the selected row
            selectedCountry = countriesArray[CountryNCityPickerView.selectedRow(inComponent: 0)].code!
            getCitiesService()
            isCountryPicked = true
            countrySelectedUpdateUI()
        }
    }
    func selectFirstRow(){
        self.CountryNCityPickerView.reloadAllComponents()
        self.CountryNCityPickerView.selectRow(0, inComponent: 0, animated: true)
        self.CountryNCityPickerView.delegate?.pickerView!(self.CountryNCityPickerView, didSelectRow: 0, inComponent: 0)
    }
    
//MARK: - Updating UI After Country Selecting Method
    func countrySelectedUpdateUI(){
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.5
        backBtn.isHidden = false
        chooseCityLbl.text = "Please choose your city"
    }
    
//MARK: - Set Initial UI Method
    func initialStateUpdateUI(){
        backBtn.isHidden = true
        isCountryPicked = false
        nextBtn.isEnabled = true
        nextBtn.alpha = 1
        chooseCityLbl.text = "Please choose your country"
    }
}
//MARK: - ConfigurationViewController Extension for UIPickerView
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
        if isCountryPicked{
            if citiesArray.count != 0 {
                if let cityName = citiesArray[row].name{pickerLabel?.text = cityName}
            }
        }else{
            if countriesArray.count != 0 {
                if let counrtyName = countriesArray[row].name{pickerLabel?.text = counrtyName}
            }
        }
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isCountryPicked{
            return citiesArray.count
        }else{
            return countriesArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isCountryPicked{
            nextBtn.isEnabled = true
            nextBtn.alpha = 1
            if citiesArray.count != 0{if let geoID = citiesArray[row].geonameId{GeoID = geoID}}
        }else{
            
        }
        
    }
    
}
