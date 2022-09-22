//
//  URL+Extension.swift
//  GoodWeather
//
//  Created by MinKyeongTae on 2022/09/23.
//

import Foundation

extension URL {
  static func urlForWeatherAPI(city: String) -> URL? {
    return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=83ac5aa4b3c35a75018e9ffe83d7060d&units=imperial")
  }
}
