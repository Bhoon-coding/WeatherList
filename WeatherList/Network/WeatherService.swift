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
    func fetchWeather(with: String) -> Observable<[WeatherInfo]>
}

final class WeatherService: WeatherServiceProtocol {
    
    func fetchWeather(with city: String) -> Observable<[WeatherInfo]> {
        return Observable.create { observer -> Disposable in
            self.fetchWeather(with: city) { result in
                switch result {
                case .failure(let error):
                    observer.onError(error)
                case .success(let weathers):
                    dump(weathers)
                    observer.onNext(weathers)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    private func fetchWeather(
        with city: String,
        completion: @escaping (Result<[WeatherInfo], NetworkError>) -> Void
    ) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(Bundle.main.apiKey)&units=metric"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            interceptor: nil,
            requestModifier: nil
        ).responseDecodable(of: WeatherResponse.self) { response in
            if response.error != nil {
                return completion(.failure(.invalidResponse))
            }
            
            if let weathers = response.value?.list {
                completion(.success(weathers))
                return
            }
            
        }
        
    }
    
}
