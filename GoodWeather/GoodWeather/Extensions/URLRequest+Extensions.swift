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
    return Observable.just(resource.url) // -> Observable<URL>
      .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request) // -> Observable<(response: HTTPURLResponse, data: Data)>
      }.map { response, data -> T in
        if 200..<300 ~= response.statusCode {
          // 정상적으로 디코딩하여 데이터를 파싱한다.
          return try JSONDecoder().decode(T.self, from: data)
        } else {
          // 에러 처리
          throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
        }
      }.asObservable() // -> Observable<T>
      
  }
  
  /*
  static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
    return Observable.from([resource.url]) // -> Observable<URL>
      .flatMap { url -> Observable<Data> in
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request) // -> Observable<Data>
      }.map { data -> T in
        return try JSONDecoder().decode(T.self, from: data) // -> T data
      }.asObservable() // -> Observable<T>
  }
   */
}
