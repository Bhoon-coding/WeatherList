//
//  WeatherService.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import Foundation

import Alamofire
import RxSwift

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFail(Error)
    case invalidResponse
    case failedResponse(statusCode: Int)
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .requestFail:
            return "HTTP 요청에 실패했습니다."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .failedResponse(let statusCode):
            return "실패 상태코드: \(statusCode)"
        case .emptyData:
            return "데이터가 없습니다."
        }
    }
}

protocol WeatherServiceProtocol {
    
    func fetchWeather(with: String) -> Observable<WeatherResponse>
    
}

final class WeatherService: WeatherServiceProtocol {
    
    func fetchWeather(with city: String) -> Observable<WeatherResponse> {
        return Observable.create { observer -> Disposable in
            let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(Bundle.main.apiKey)&units=metric"

            if let url = URL(string: urlString) {
                AF.request(
                    url,
                    method: .get,
                    encoding: JSONEncoding.default
                ).responseDecodable(of: WeatherResponse.self) { response in
                    if response.error != nil {
                        observer.onError(response.error ?? NetworkError.invalidResponse)
                    }
                    
                    if let weathersResponse = response.value {
                        observer.onNext(weathersResponse)
                    }
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
        
    }
    
}
