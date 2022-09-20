//
//  URLRequest+Extensions.swift
//  GoodWeather
//
//  Created by MinKyeongTae on 2022/09/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
  let url: URL
}

extension URLRequest {
  static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
    return Observable.from([resource.url]) // -> Observable<URL>
      .flatMap { url -> Observable<Data> in
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request) // -> Observable<Data>
      }.map { data -> T in
        return try JSONDecoder().decode(T.self, from: data) // -> T data
      }.asObservable() // -> Observable<T>
  }
}
