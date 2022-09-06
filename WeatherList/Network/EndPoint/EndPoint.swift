//
//  EndPoint.swift
//  WeatherList
//
//  Created by BH on 2022/09/06.
//

import Foundation

protocol EndPointType {
    
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    
    func asURLRequest() -> URLRequest?
}

extension EndPointType {
    
    func asURLRequest() -> URLRequest? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        
        guard let url = components?.url else { return nil }
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
}
