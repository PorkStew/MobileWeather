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
    //let main: main
}
struct List: Codable {
    let dt: Double
    let dt_txt: String
    //let main: Mains
    let main: main
}
struct main: Codable {
    //let temp: Double
    let temp: Double
}
