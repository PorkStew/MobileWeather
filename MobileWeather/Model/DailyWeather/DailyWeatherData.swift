//
//  DailyWeatherData.swift
//  MobileWeather
//
//  Created by Stewart Clay on 2022/10/18.
//

import Foundation

struct DailyWeatherData: Codable {
    let list: [List]
    let cnt: Int
}
struct List: Codable {
    let dt: Double
    let dt_txt: String
    let main: main
    let weather: [weather]
}
struct main: Codable {
    let temp: Double
}
struct weather: Codable {
    let id: Int
}
