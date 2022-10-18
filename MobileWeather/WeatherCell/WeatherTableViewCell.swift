//
//  WeatherTableViewCell.swift
//  MobileWeather
//
//  Created by Stewart Clay on 2022/10/17.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherSymbol: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    static let identifier = "WeatherTableViewCell"
//    
//    static func nib() -> UINib {
//        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
//    }
}
