//
//  HomeViewModel.swift
//  Storm
//
//  Created by Mohammad Zakizadeh on 7/17/18.
//  Copyright © 2018 Storm. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
  public enum HomeError : Error {
    case internetError(String)
    case serverMessage(String)
  }
  
  // MARK: HomeViewController의 View들과 바인딩될 Subject들을 선언
  // 각각의 subject들은 변화가 필요한 시점에 이벤트를 방출하며, 바인딩 된 UI도 그에 따라 변화한다.
  public let albumsSubject : PublishSubject<[Album]> = PublishSubject()
  public let tracksSubject : PublishSubject<[Track]> = PublishSubject()
  public let loadingSubject: PublishSubject<Bool> = PublishSubject()
  public let errorSubject : PublishSubject<HomeError> = PublishSubject()
  
  public func requestData() {
    // API 요청 전 loadingView를 띄움
    self.loadingSubject.onNext(true)
    APIManager.requestData(url: "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json", method: .get, parameters: nil, completion: { (result) in
      // 요청 완료 후, 결과 상관없이 loadingView를 가림
      // 요청 결과에 맞게 subject observable event를 방출
      self.loadingSubject.onNext(false)
      switch result {
      case .success(let returnJson) :
        let albums = returnJson["Albums"].arrayValue
          .compactMap {
            guard let rawData = try? $0.rawData() else { return nil }
            return rawData
          }
          .compactMap(Album.init)
        let tracks = returnJson["Tracks"].arrayValue
          .compactMap {
            guard let rawData = try? $0.rawData() else { return nil }
            return rawData
          }
          .compactMap(Track.init)
        self.albumsSubject.onNext(albums)
        self.tracksSubject.onNext(tracks)
      case .failure(let failure) :
        switch failure {
        case .connectionError:
          self.errorSubject.onNext(.internetError("Check your Internet connection."))
        case .authorizationError(let errorJson):
          self.errorSubject.onNext(.serverMessage(errorJson["message"].stringValue))
        default:
          self.errorSubject.onNext(.serverMessage("Unknown Error"))
        }
      }
    })
  }
}
