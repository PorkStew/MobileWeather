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
    let temp_min: Double
    let temp_max: Double
    //let humidity: Int
}

struct Weather: Codable {
    let description: String
    let id: Int
}

//struct List: Codable {
  //  let main: Main
//}

