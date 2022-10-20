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
protocol DailyWeatherManagerDelegate {
    func didUpdateWeather(_ DailyWeatherManager: DailyWeatherManager, dailyWeather: DailyWeatherModel)
    func didFailWithError(error: Error)
}

struct DailyWeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=f468ed161a9fbfaa134527067d0b0c20&units=metric"
    
    var delegate: DailyWeatherManagerDelegate?
    let dateFormatter = DateFormatter()
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
                    if let weather = self.parseJSON(dailyWeatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, dailyWeather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    //Decode the data based on the Daily Weather Data structs in the WeatherData.swift file
    //Return the data in the structs fround in the DailyWeatherModel.swift file
    func parseJSON(dailyWeatherData: Data) -> DailyWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DailyWeatherData.self, from: dailyWeatherData)
            let dates = decodedData.list[0].dt_txt
            let startDate = dateConverter(date: dates)
            //Variable Declerations
            var forecast = [Int]()
            var temperature = [Double]()
            var forecastIcon = [Int]()
            var weekName = [String]()
            var count = 0
            
            //The API gives weather in 3 hours, we need one day weather forecast
            //This loop and if statement gets rid of the 3 hours and shows the predicted weather for each day
            //If the predicted days weather has already been added skip till a new day is found
            while count < decodedData.list.count-1 {
                count += 1
                var weekday: String = ""
                let date = decodedData.list[count].dt_txt
                let nextData = dateConverter(date: date)
                
                if startDate != nextData && forecast.contains(nextData) == false{
                    forecast.append(nextData)
                    temperature.append(decodedData.list[count].main.temp)
                    forecastIcon.append(decodedData.list[count].weather[0].id)
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    //Function to convert String to Date data type and retrive the date e.g 21 october 2022 to 21
                    //This then will allow us to get the weekday name
                    let dailyDate = dateFormatter.date(from:date)!
                    dateFormatter.dateFormat = "cccc"
                    weekday = dateFormatter.string(from: dailyDate)
                    weekName.append(weekday)
                }
            }
            //Add weather data to WeatherModel and return its data to be used in the WeatherViewController
            let weather = DailyWeatherModel(days: forecast, temp: temperature, conditionId: forecastIcon, weekName: weekName)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    //convert each string date from the API to a date data type
    func dateConverter(date: String) -> Int{
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:date)!
        let calanderDate = Calendar.current.dateComponents([.day], from: date).day!
        return calanderDate
    }
}
