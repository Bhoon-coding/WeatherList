//
//  WeatherViewModel.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import Foundation

final class WeatherViewModel {
    
    private let weatherResponse: WeatherResponse
    private let weatherInfo: WeatherInfo
    

    var city: String? {
        return weatherResponse.city?.name
    }
    
    var date: String? {
        // TODO: [] 날짜 계산 후 표현 [오늘, 내일, 3일차부터 (요일 일 월) 날짜표시]
        return weatherInfo.date
    }

    var imageURL: String? {
        return weatherInfo.weather?[0].icon
    }

    var main: String? {
        return weatherInfo.weather?[0].main
    }

    var maxTemp: Double {
        return weatherInfo.temp.tempMax
    }

    var minTemp: Double {
        return weatherInfo.temp.tempMin
    }
    
    init(
        weatherResponse: WeatherResponse,
        weatherInfo: WeatherInfo
    ) {
        self.weatherResponse = weatherResponse
        self.weatherInfo = weatherInfo
    }
    
}
