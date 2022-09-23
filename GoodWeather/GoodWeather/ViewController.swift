//
//  ViewController.swift
//  GoodWeather
//
//  Created by MinKyeongTae on 2022/09/21.
//

// MARK - 76. What are Binding Observables?
// Observable 동작에는 Producer, Receiver가 있습니다. UI를 바인딩할때 사용하는 bintTo를 사용해봅니다.
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

    // 텍스트필드 편집을 마쳤을때에 API 호출을 해서 UI 업데이트 한다.
    self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit) // CcntrolEvent<()>
      .asObservable() // -> Observable<()>
      .map { self.cityNameTextField.text }
      .subscribe(onNext: { [weak self] city in
        if let city = city {
          if city.isEmpty {
            DispatchQueue.main.async {
              self?.displayWeather(nil)
            }
          } else {
            self?.fetchWeather(by: city)
          }
        }
      }).disposed(by: disposeBag)
    
    // cityNameTextField.rx.value를 구독하면 텍스트필드가 입력될때마다 입력된 값을 감지합니다.
    // 텍스트가 입력될때마다 API를 호출하는 것은 비효율적이다. 버튼이나 텍스트필드를 터치했을때 API 결과를 받아오는게 어떨까
    // 텍스트 문자 입력 시마다 API호출 되는게 아닌, 편집 종료시에만 1회 호출 후 UI 업데이트
    /*
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
     */
  }
  
  private func fetchWeather(by city: String) {
    guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
          let url = URL.urlForWeatherAPI(city: cityEncoded) else {
      return
    }
    let resource = Resource<WeatherResult>(url: url)
    
    // bindTo를 사용하지 않았을때 구현 예시
    /*
    URLRequest.load(resource: resource)
      .catchAndReturn(WeatherResult.empty)
      .subscribe(onNext: { [weak self] result in
        let weather = result.main
        DispatchQueue.main.async {
          // 일반적인 UI 데이터 업데이트는 아래와 같이 할 수 있지만, reactive하게 구현한다면 UI와 Observable 데이터의 binding을 할 수 있다.
          self?.displayWeather(weather)
        }
      }).disposed(by: disposeBag)
     */
    // RxCcooa, bindTo를 통해 Observable과 UI를 바인딩하여 Observable 이벤트 발생 마다 UI를 업데이트 시킬 수 있습니다.
    // 또 다른 UI 바인딩 방법으로 driver가 있습니다. driver를 다음시간에 사용해봐요.
    // 1) observe, bind 사용 예시
    /*
    let searchObservable = URLRequest.load(resource: resource)
      .observe(on: MainScheduler.instance) // UI 업데이트는 Main 스레드에서 동작해야해요.
      .catchAndReturn(WeatherResult.empty) // 에러 발생시 빈 데이더를 전달
     
     searchObservable.map { "\($0.main.temp) 𝐅" }
       .bind(to: self.temperatureLabel.rx.text) // searchObservable에서 temp 값이 방출 될때마다 바인딩 된 temperatureLabel 텍스트가 업데이트 됩니다.
       .disposed(by: disposeBag)
     
     searchObservable.map { "\($0.main.humidity) 🍉" }
       .bind(to: self.humidityLabel.rx.text) // searchObservable에서 humidiy 값이 방출 될때마다 바인딩 된 humidityLabel 텍스트가 업데이트 됩니다.
       .disposed(by: disposeBag)
     */
    
    // 2) driver 사용 예시
    // control property, driver란 무엇인가?
    // rx.controlEvent : UI의 다양한 이벤트를 구독하여 감지할 수 있다. 특정 UI 이벤트가 발생할때마다 이벤트가 trigger된다.
    // driver : driver는 항상 Main thraed에서 동작을 하기때문에 Main thread에서만 동작해야하는 UI를 감지할때 사용할 수 있습니다.
    // Observable을 asDriver로 Driver 변환이 가능하며, bind 대신 drive로 UI를 바인딩할 수 있습니다.
    
    let searchObservable = URLRequest.load(resource: resource)
      .retry(3) // retry three times, 재시도를 통해 이벤트 정상 처리가 가능한 경우, 다시 이벤트를 감지할 수 있다.
      .catch { error in // catch는 에러를 처리할때 사용할 수 있다.
        print(error.localizedDescription) // ex) httpRequestFailed 관련 에러
        return Observable.just(WeatherResult.empty)
      }.asDriver(onErrorJustReturn: WeatherResult.empty) // 에러 발생 시, WeatherResult.empty를 전달합니다.
    searchObservable.map { "\($0.main.temp) 𝐅"}
      .drive(self.temperatureLabel.rx.text)
      .disposed(by: disposeBag)
    searchObservable.map { "\($0.main.humidity) ⺢"}
      .drive(self.humidityLabel.rx.text)
      .disposed(by: disposeBag)
  
    // 80. Disposing with RxCocoa
    // 클로져 내 캡쳐리스트는 어떨때 사용해야할까?
    // 1) nothing : viewController, 싱글턴 내부 등 클로져 내부가 아닌 일반적인 케이스
    // 2) unowned : 모든 viewController들 의 클로져 실행 된 이후의 케이스 (nil이 되면 앱 크래시를 유발하므로 주의해서 사용)
    // 3) weak : 그 외 모든 케이스
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

