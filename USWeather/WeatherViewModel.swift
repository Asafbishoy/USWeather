//
//  WeatherViewModel.swift
//  USWeather
//
//  Created by Kranthi v on 30/05/23.
//

import Foundation

class WeatherViewModel {
    private let apiKey = "4150c4040953a963cdb4e69a0e49700c"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    var weatherData: WeatherData?
    
    func fetchWeatherData(city: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
