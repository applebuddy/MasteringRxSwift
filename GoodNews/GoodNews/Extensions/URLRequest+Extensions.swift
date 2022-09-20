//
//  URLRequest+Extensions.swift
//  GoodNews
//
//  Created by MinKyeongTae on 2022/09/21.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
  let url: URL
}

extension URLRequest {
  /// Resource 제네릭 구조체를 구독가능한 Observable<T?> 타입으로 반환해줍니다.
  static func load<T>(resource: Resource<T>) -> Observable<T?> {
    return Observable.from([resource.url])
      .flatMap { url -> Observable<Data> in
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request)
      }.map { data -> T? in
        return try? JSONDecoder().decode(T.self, from: data)
      }.asObservable()
  }
}
