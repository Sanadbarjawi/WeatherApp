//
//  CitiesDataModel.swift
//  WeatherApp
//
//  Created by Sanad  on 6/22/18.
//  Copyright © 2018 Sanad LTD. All rights reserved.
//

import Foundation
class CitiesDataModel:Decodable{
    var geonames = [geoNamesModel]()
}
class geoNamesModel:Decodable {
    var name:String?
    var geonameId:Int?
}
