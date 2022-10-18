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
                        //self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(dailyWeatherData: Data) -> DailyWeatherModel? {
        let decoder = JSONDecoder()
        do {
            //let decodedData = try decoder.decode(WeatherData.self, from: DailyWeatherData)
            let decodedData = try decoder.decode(DailyWeatherData.self, from: dailyWeatherData)
            
            let cnt = decodedData.list[0].dt
            print(cnt)
            
            
            
            let date = decodedData.list[0].dt_txt
            
            let startDate = dateConverter(date: date)
            
            var count = 0
            let d = startDate + 6
            
            var forecast = [Int]()
            var temperature = [Double]()
            
            while count < decodedData.list.count-1 {
                count += 1
                let date = decodedData.list[count].dt_txt
                let nextData = dateConverter(date: date)
                print("start: \(startDate) next: \(nextData)")
                if startDate != nextData && forecast.contains(nextData) == false{
                    forecast.append(nextData)
                    temperature.append(decodedData.list[count].main.temp)
                } else {
                    print("sdsdsd")
                }
                
            }
            print(forecast)
            print(temperature)
//                print("fffffff \(startDate)")
//                let date = decodedData.list[count].dt_txt
//                print(date)
//                let NextDate = dateConverter(date: date)
//                if NextDate != startDate {
//                    print(count)
//                } else {
//                    count += 1
//                }
//            }
            
            
            //let temperature = decodedData.main.temp
            //let temperature = decodedData.list.main.temp
//            let id = decodedData.weather[0].id
//            let temp = decodedData.main.temp
//            let name = decodedData.name
//            let minTemp = decodedData.main.temp_min
//            let maxTemp = decodedData.main.temp_max
//            let weatherDescription = decodedData.weather[0].description
//
            //let weather = DailyWeatherModel(temp: temperature)
            //print("ffffffffff")
            let weather = DailyWeatherModel(days: forecast, temp: temperature)
            
            return weather
            
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    func dateConverter(date: String) -> Int{
          let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:date)!
        let calanderDate = Calendar.current.dateComponents([.day], from: date).day!
        
        print(calanderDate)
        return calanderDate
    }
}
