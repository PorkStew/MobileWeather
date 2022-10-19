//
//  ViewController.swift
//  MobileWeather
//
//  Created by Stewart Clay on 2022/10/12.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate {
    //IBOutlet Declarations
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var weatherManager = WeatherManager()
    var dailyWeatherManager = DailyWeatherManager()
    var locationManager = CLLocationManager()
    //Variable Declarations
    var fore: [Int] = []
    var foreTemp: [Double] = []
    var foreSymbol: [Int] = []
    var weekname: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register weathertableview cell
        table.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        table.delegate = self
        table.dataSource = self
        
        //Froce uppercase text for min, current, max
        weatherDescription.text = weatherDescription.text?.uppercased()
        //Register delegates
        weatherManager.delegate = self
        dailyWeatherManager.delegate = self
        locationManager.delegate = self
        //CLLocationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            dailyWeatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            print("Inside WeatherManagerDelegate")
            self.temperatureLabel.text = weather.temperatureString + "°"
            self.weatherDescription.text = weather.weatherDescription
            self.minTemp.text = weather.temperatureMinString
            self.currentTemp.text = weather.temperatureString
            self.maxTemp.text = weather.temperatureMaxString
            print(weather.weatherDescription)
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - DailyWeatherManagerDelegate
extension WeatherViewController: DailyWeatherManagerDelegate {
    func didUpdateWeather(_ dailyWeatherManager: DailyWeatherManager, weather: DailyWeatherModel) {
        DispatchQueue.main.async {
            
            print("We are in didUpdateWeather")
            self.fore = weather.days
            print("WEAHTER ID: \(weather.conditionId)")
            self.foreSymbol = weather.conditionId
            self.foreTemp = weather.temp
            self.table.reloadData()
            print("reloading table for you")
            //self.forecast.append(weather.days)
            self.weekname = weather.weekName
            print("fiofjegojwegjeifneiljgnerwg")
        }
    }
    
}


//MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        DispatchQueue.main.async {
            if self.fore.count != 0 {
                cell.dayLabel.text = String(self.weekname[indexPath.row])
                switch self.foreSymbol[indexPath.row] {
                case 200...232:
                    cell.weatherSymbol.image = UIImage(systemName: "cloud.bolt")
                case 300...321:
                    cell.weatherSymbol.image = UIImage(systemName: "cloud.drizzle")
                case 500...531:
                    cell.weatherSymbol.image = UIImage(systemName: "cloud.rain")
                case 600...622:
                    cell.weatherSymbol.image = UIImage(systemName: "cloud.snow")
                case 701...781:
                    cell.weatherSymbol.image = UIImage(systemName: "cloud.fog")
                case 800:
                    cell.weatherSymbol.image = UIImage(systemName: "sun.max")
                case 801...804:
                    cell.weatherSymbol.image = UIImage(systemName: "cloud.bolt")
                default:
                    cell.weatherSymbol.image = UIImage(systemName: "cloud")
                }
                cell.temperatureLabel.text = String(self.foreTemp[indexPath.row])
            }
        }
        return cell
    }
}
