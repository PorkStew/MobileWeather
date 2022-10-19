//
//  WeatherModel.swift
//  MobileWeather
//
//  Created by Stewart Clay on 2022/10/12.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let tempMin: Double
    let tempMax: Double
    let weatherDescription: String

    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    var temperatureMinString: String {
        return String(format: "%.1f", tempMin)
    }
    var temperatureMaxString: String {
        return String(format: "%.1f", tempMax)
    }
}
