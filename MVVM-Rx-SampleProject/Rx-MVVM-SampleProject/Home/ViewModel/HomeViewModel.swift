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
  
  public enum HomeError {
    case internetError(String)
    case serverMessage(String)
  }
  
  // HomeViewController의 View들과 바인딩될 Subject들을 선언
  public let albums : PublishSubject<[Album]> = PublishSubject()
  public let tracks : PublishSubject<[Track]> = PublishSubject()
  public let loading: PublishSubject<Bool> = PublishSubject()
  public let error : PublishSubject<HomeError> = PublishSubject()
  
  private let disposable = DisposeBag()

  public func requestData() {
    
    self.loading.onNext(true)
    APIManager.requestData(url: "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json", method: .get, parameters: nil, completion: { (result) in
      self.loading.onNext(false)
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
        self.albums.onNext(albums)
        self.tracks.onNext(tracks)
      case .failure(let failure) :
        switch failure {
        case .connectionError:
          self.error.onNext(.internetError("Check your Internet connection."))
        case .authorizationError(let errorJson):
          self.error.onNext(.serverMessage(errorJson["message"].stringValue))
        default:
          self.error.onNext(.serverMessage("Unknown Error"))
        }
      }
    })
  }
}
