//
//  WeatherManager.swift
//  Clima
//
//  Created by Stewart Clay on 2022/09/04.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol DailyWeatherManagerDelegate {
    func didUpdateWeather(_ DailyWeatherManager: DailyWeatherManager, weather: DailyWeatherModel)
    func didFailWithError(error: Error)
}

struct DailyWeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=f468ed161a9fbfaa134527067d0b0c20&units=metric"
    
    var delegate: DailyWeatherManagerDelegate?
    let dateFormatter = DateFormatter()
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
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
                    if let weather = self.parseJSON(dailyWeatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(dailyWeatherData: Data) -> DailyWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DailyWeatherData.self, from: dailyWeatherData)
            
            //let cnt = decodedData.list[0].dt
            let dates = decodedData.list[0].dt_txt
            let startDate = dateConverter(date: dates)
            
            var count = 0
            //let d = startDate + 6
            
            var forecast = [Int]()
            var temperature = [Double]()
            var forecastIcon = [Int]()
            var weekName = [String]()
            
            while count < decodedData.list.count-1 {
                count += 1
                let date = decodedData.list[count].dt_txt
                let nextData = dateConverter(date: date)
                
                print("start: \(startDate) next: \(nextData)")
                if startDate != nextData && forecast.contains(nextData) == false{
                    forecast.append(nextData)
                    print("what what what what what")
                    print(decodedData.list[count].weather[0].id)
                    print("asdasdasdjisifiewjfiewrngiorehgnieringoierohigeroihjgoijnerwijngi")
                    temperature.append(decodedData.list[count].main.temp)
                    forecastIcon.append(decodedData.list[count].weather[0].id)
                    
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let da = dateFormatter.date(from:date)!
                    var weekday: String = ""
                    dateFormatter.dateFormat = "cccc"
                    weekday = dateFormatter.string(from: da)
                    weekName.append(weekday)
                    
                } else {
                    print("sdsdsd")
                }
                
            }
            print(forecast)
            print(temperature)
            print(forecastIcon)
            print(weekName)
            let weather = DailyWeatherModel(days: forecast, temp: temperature, conditionId: forecastIcon, weekName: weekName)
            print("returning weather")
            return weather
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    func dateConverter(date: String) -> Int{
          
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:date)!
        let calanderDate = Calendar.current.dateComponents([.day], from: date).day!
        
        print(calanderDate)
        return calanderDate
    }
}
