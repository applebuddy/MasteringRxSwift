//
//  URLRequest+Extensions.swift
//  NewsMVVMApp
//
//  Created by MinKyeongTae on 2022/09/24.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
  let url: URL
}

extension URLRequest {
  static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
    return Observable.just(resource.url) // -> Observable<URL>
      .flatMap { url -> Observable<Data> in
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request) // -> Observable<Data>
      }.map { data -> T in
        return try JSONDecoder().decode(T.self, from: data) // -> Observable<T>
      }
  }
}
