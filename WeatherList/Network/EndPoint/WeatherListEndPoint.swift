//
//  WeatherListEndPoint.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import Foundation

struct WeatherListEndPoint: EndPointType {
    
    var baseURL: String {
            return "api.openweathermap.org"
        }
    
    var path: String {
            return "/data/2.5/forecast"
        }
    
    var queryItems: [URLQueryItem]? {
            return [URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: units)]
        }
    
    var apiKey: String {
        guard let apiKey = Bundle.main.apiKey else {
            print("API_KEY가 없습니다.")
            return ""
        }
        return apiKey
    }
    
    var city: String
    var units: String {
        return "metric"
    }
    
}
