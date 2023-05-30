//
//  WeatherViewController.swift
//  USWeather
//
//  Created by Kranthi v on 30/05/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
       @IBOutlet weak var humidityLabel: UILabel!
       @IBOutlet weak var descriptionLabel: UILabel!
       @IBOutlet weak var weatherIconImageView: UIImageView!
       
       var weatherData: WeatherData?
       
       override func viewDidLoad() {
           super.viewDidLoad()
           updateUI()
       }
       
       private func updateUI() {
           guard let weatherData = weatherData else { return }
           let celsiusTemperature = weatherData.main.temp - 273.15
           temperatureLabel.text = "\(celsiusTemperature)°"
           humidityLabel.text = "\(weatherData.main.humidity)%"
           descriptionLabel.text = weatherData.weather.first?.description
           
           if let icon = weatherData.weather.first?.icon {
               let iconUrlString = "https://openweathermap.org/img/wn/\(icon).png"
               guard let iconUrl = URL(string: iconUrlString) else { return }
               DispatchQueue.global().async {
                   if let data = try? Data(contentsOf: iconUrl) {
                       DispatchQueue.main.async {
                           self.weatherIconImageView.image = UIImage(data: data)
                       }
                   }
               }
           }
       }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
