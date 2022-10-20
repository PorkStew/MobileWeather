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
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var currentWeatherBackground: UIImageView!
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
    var foreTemp: [Double] = []
    var foreSymbol: [Int] = []
    var weekname: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register weathertableview cell
        table.register(UINib(nibName: C.cellIdentifier, bundle: nil), forCellReuseIdentifier: C.cellIdentifier)
        table.delegate = self
        table.dataSource = self
        //sets height for each cell in table
        table.rowHeight = 50
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
            print(weather.conditionId)
            //This checks the weatherid, based on that displays the corrospinding images and background color
            switch weather.conditionId {
            case 200...232:
                self.currentWeatherBackground.image = UIImage(named: "forest_rainy")
                self.viewBackground.backgroundColor = UIColor(named: C.Colors.rain)
            case 300...321:
                self.currentWeatherBackground.image = UIImage(named: "forest_rainy")
                self.viewBackground.backgroundColor = UIColor(named: C.Colors.rain)
            case 500...531:
                self.currentWeatherBackground.image = UIImage(named: "rain")
                self.viewBackground.backgroundColor = UIColor(named: C.Colors.rain)
            case 600...622:
                self.currentWeatherBackground.image = UIImage(named: "forest_rainy")
                self.viewBackground.backgroundColor = UIColor(named: C.Colors.rain)
            case 701...781:
                self.currentWeatherBackground.image = UIImage(named: "forest_cloudy")
                self.viewBackground.backgroundColor = UIColor(named: C.Colors.cloudy)
            case 800:
                self.currentWeatherBackground.image = UIImage(named: "forest_sunny")
                self.viewBackground.backgroundColor = UIColor(named: C.Colors.green)
            case 801...804:
                self.currentWeatherBackground.image = UIImage(named: "forest_rainy")
                self.viewBackground.backgroundColor = UIColor(named: C.Colors.rain)
            default:
                self.currentWeatherBackground.image = UIImage(named: "PartlySunny")
                
            }
            self.temperatureLabel.text = weather.temperatureString + "°"
            self.weatherDescription.text = weather.weatherDescription
            self.minTemp.text = weather.temperatureMinString
            self.currentTemp.text = weather.temperatureString
            self.maxTemp.text = weather.temperatureMaxString
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - DailyWeatherManagerDelegate
extension WeatherViewController: DailyWeatherManagerDelegate {
    func didUpdateWeather(_ dailyWeatherManager: DailyWeatherManager, dailyWeather: DailyWeatherModel) {
        DispatchQueue.main.async {
            self.foreSymbol = dailyWeather.conditionId
            self.foreTemp = dailyWeather.temp
            self.weekname = dailyWeather.weekName
            self.table.reloadData()
        }
    }
    
}

//MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //We return 5 because that is based on the number of days of predited weather that must be shown
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        DispatchQueue.main.async {
            //This an index out of bounds error check to make sure the array has content
            if self.weekname.count != 0 {
                cell.dayLabel.text = String(self.weekname[indexPath.row])
                //Based on the weatherid, show the corrosponding weather icon
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
                //converts daily temperature to one decimal place
                let temp = String(format: "%.1f", self.foreTemp[indexPath.row])
                cell.temperatureLabel.text = temp + "°"
            }
        }
        return cell
    }
}
