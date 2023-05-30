//
//  ViewController.swift
//  USWeather
//
//  Created by Kranthi v on 30/05/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

        @IBOutlet weak var cityTextField: UITextField!
        @IBOutlet weak var searchButton: UIButton!
    
        let locationManager = CLLocationManager()
        private let viewModel = WeatherViewModel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Auto-load last city searched
            let lastSearchedCity = UserDefaults.standard.string(forKey: "LastSearchedCity")
            cityTextField.text = lastSearchedCity
            
            // Request location access
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            
            configureUI()
           // loadLastSearchedCity()
        }
        
        private func configureUI() {
            searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        }
        
        private func loadLastSearchedCity() {
            // Load the last searched city from local storage and update the UI
            let lastSearchedCity = UserDefaults.standard.string(forKey: "LastSearchedCity")
            cityTextField.text = lastSearchedCity
            fetchWeatherData(city: lastSearchedCity ?? "-")
        }
        
        @objc private func searchButtonTapped() {
            guard let city = cityTextField.text else {
                showAlert(with: "Please enter a city name.")
                return }
            fetchWeatherData(city: city)
        }
        
        private func fetchWeatherData(city: String) {
            viewModel.fetchWeatherData(city: city) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        // Update the UI with weather data
                        self.performSegue(withIdentifier: "WeatherSegue", sender: nil)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        // Show error alert to the user
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "WeatherSegue" {
                if let weatherViewController = segue.destination as? WeatherViewController {
                    weatherViewController.weatherData = viewModel.weatherData
                }
            }
        }
        
        override func performSegue(withIdentifier identifier: String, sender: Any?) {
            if identifier == "WeatherSegue" {
                guard let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController else {
                    fatalError("Unable to instantiate WeatherViewController")
                }
                destinationViewController.weatherData = viewModel.weatherData
                navigationController?.pushViewController(destinationViewController, animated: true)
            } else {
                super.performSegue(withIdentifier: identifier, sender: sender)
            }
        }

    
    private func showAlert(with message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

}




extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let error = error {
                    self?.showAlert(with: error.localizedDescription)
                    return
                }
                
                if let city = placemarks?.first?.locality {
                    self?.fetchWeatherData(city: city)
                }
            }
        }
    }
}
