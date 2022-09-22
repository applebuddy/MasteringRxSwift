//
//  ViewController.swift
//  GoodWeather
//
//  Created by MinKyeongTae on 2022/09/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  @IBOutlet weak var cityNameTextField: UITextField!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    // cityNameTextField.rx.value를 구독하면 텍스트필드가 입력될때마다 입력된 값을 감지합니다.
    self.cityNameTextField.rx.value
      .subscribe(onNext: { [weak self] city in
        if let city = city {
          if city.isEmpty {
            self?.displayWeather(nil)
          } else {
            self?.fetchWeather(by: city)
          }
        }
      }).disposed(by: disposeBag)
  }
  
  private func fetchWeather(by city: String) {
    guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
          let url = URL.urlForWeatherAPI(city: cityEncoded) else {
      return
    }
    let resource = Resource<WeatherResult>(url: url)
    URLRequest.load(resource: resource)
      .catchAndReturn(WeatherResult.empty)
      .subscribe(onNext: { [weak self] result in
        let weather = result.main
        DispatchQueue.main.async {
          self?.displayWeather(weather)
        }
      }).disposed(by: disposeBag)
  }
  
  private func displayWeather(_ weather: Weather?) {
    if let weather = weather {
      self.temperatureLabel.text = "\(weather.temp) F"
      self.humidityLabel.text = "\(weather.humidity) ⺢"
    } else {
      self.temperatureLabel.text =  "🐵"
      self.humidityLabel.text = "😢"
    }
  }
}

