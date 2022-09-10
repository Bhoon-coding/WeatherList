//
//  WeatherResponse.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import Foundation

struct WeatherResponse: Decodable {
    
    let statusCode: String?
    let count: Int?
    let list: [WeatherInfo]?
    let city: City?
    
    enum CodingKeys: String, CodingKey {
        
        case statusCode = "cod"
        case count = "cnt"
        case list
        case city
        
    }
    
}

struct WeatherInfo: Decodable {
    
    let temp: Temp
    let weather: [Weather]?
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        
        case temp = "main"
        case weather
        case date = "dt_txt"
        
    }
    
}

struct City: Decodable {
    
    let name: String
    
}

struct Temp: Decodable {
    
    let tempMin: Double
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
