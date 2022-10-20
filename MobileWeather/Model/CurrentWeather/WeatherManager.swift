//
//  WeatherManager.swift
//  Clima
//
//  Created by Stewart Clay on 2022/09/04.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

//Weather Delegate
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f468ed161a9fbfaa134527067d0b0c20&units=metric"
    
    var delegate: WeatherManagerDelegate?
    //Fetch Weather based on city name
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    //Fetch Weather based on longitude and Latitude
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    //Fetch data from the weather URL
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    //Decode the data based on the Weather Data structs in the WeatherData.swift file
    //Return the data in the structs fround in the WeatherModel.swift file
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let minTemp = decodedData.main.temp_min
            let maxTemp = decodedData.main.temp_max
            let weatherDescription = decodedData.weather[0].description
            //Add weather data to WeatherModel and return its data to be used in the WeatherViewController
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, tempMin: minTemp, tempMax: maxTemp ,weatherDescription: weatherDescription)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
