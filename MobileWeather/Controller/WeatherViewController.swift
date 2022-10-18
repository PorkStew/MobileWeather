//
//  ViewController.swift
//  MobileWeather
//
//  Created by Stewart Clay on 2022/10/12.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var weatherManager = WeatherManager()
    var dailyWeatherManager = DailyWeatherManager()
    var locationManager = CLLocationManager()
    
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
    func didUpdateWeather(_ DailyWeatherManager: DailyWeatherManager, weather: DailyWeatherModel) {
        DispatchQueue.main.async {
            //print(weather.temperatureString)
            self.temperatureLabel.text = String(weather.days)
            print(weather.days)
            print("fiofjegojwegjeifneiljgnerwg")
            
        }
    }
}

//MARK: - UITableViewDelegate
//extension WeatherViewController: UITableViewDelegate {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//}

//MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        cell.temperatureLabel.text = "2"
        return cell
    }
}
