//
//  WeatherResponse.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import Foundation
import RxDataSources

struct SectionOfWeatherResponse {
    var header: String
    var items: [WeatherInfo]
}

extension SectionOfWeatherResponse: SectionModelType {
    
    typealias Item = WeatherInfo
    
    init(original: SectionOfWeatherResponse, items: [Item]) {
        self = original
        self.items = items
    }
    
}

struct WeatherResponse: Decodable {
    
    var statusCode: String?
    var count: Int?
    var list: [WeatherInfo]?
    var city: City?
    
    enum CodingKeys: String, CodingKey {
        
        case statusCode = "cod"
        case count = "cnt"
        case list
        case city
        
    }
    
}

struct WeatherInfo: Decodable {
    
    var temp: Temp
    var weather: [Weather]?
    var date: String
    
    enum CodingKeys: String, CodingKey {
        
        case temp = "main"
        case weather
        case date = "dt_txt"
        
    }
    
}

struct City: Decodable {
    
    var name: String
    
}

struct Temp: Decodable {
    
    var tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
}

struct Weather: Decodable {
    
    let id: Int
    let main: String?
    let icon: String?
    
}
