//
//  WeatherData.swift
//  USWeather
//
//  Created by Kranthi v on 30/05/23.
//

import Foundation

import Foundation

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
    let icon: String
}
