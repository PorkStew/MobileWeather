//
//  WeatherData.swift
//  MobileWeather
//
//  Created by Stewart Clay on 2022/10/12.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
