//
//  String + extension.swift
//  WeatherList
//
//  Created by BH on 2022/09/10.
//

import Foundation

extension String {
    
    func setDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let stringFormatter = DateFormatter()
        stringFormatter.dateFormat = "E d MMM"
        
        if let check = dateFormatter.date(from: self) {
            return stringFormatter.string(from: check)
        } else {
            return "날짜없음"
        }
        
    }
    
}
