//
//  MainViewModel.swift
//  WeatherList
//
//  Created by BH on 2022/09/07.
//

import Foundation

import RxSwift

final class MainViewModel {
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func fetchWeathers() -> Observable<[WeatherResponse]> {
        weatherService.fetchWeather(with: "seoul")
    }
    
}
