//
//  WeatherResult.swift
//  GoodWeather
//
//  Created by MinKyeongTae on 2022/09/21.
//

import Foundation

struct WeatherResult: Decodable {
  let main: Weather
}

struct Weather: Decodable {
  let temp: Double
  let humidity: Double
}
