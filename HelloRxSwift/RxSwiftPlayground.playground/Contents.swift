import UIKit
import RxSwift

var greeting = "Hello, playground"

// just : Observable의 타입 메서드, 단 한개의 값만을 생성한다..
// Observable<Int>
let observableJust = Observable.just(1)

// of : Observable의 타입 메서드, of는 다수의 값을 생성 가능하다.
// Observable<Int>
let observableOf = Observable.of(0, 1, 2)

// 아래와 같이 배열값도 생성 가능하다. [Int]를 받았을때, Observable<[Int]> 타입이 된다.
// Observable<[Int]>
let observableOf2 = Observable.of([0, 1, 2])

// 위에 선언한 Observable들은 구독하기 전에는 별다른 이벤트가 없다.
// from : from은 Sequence 배열 자체를 인자로 받는다. [Int]를 받았을때, Observable<Int> 타입이 된다.
// Observable<Int>
let observableFrom = Observable.from([0, 1, 2, 3, 4])

// 다음 시간에 Observable들에 대한 구독이 어떻게 생성되는지를 알아보자.

// MARK: - lecture 10. Implementing Subscriptions
observableFrom.subscribe { event in
  debugPrint(event)
  if let element = event.element {
    // from 연산자는 배열 내의 원소가 순차적으로 방출됩니다.
    print(element)
  }
  // 모든 값이 방출 된 이후에는 completed 이벤트가 방출됩니다.
}

observableOf2.subscribe { event in
  print(event)
  if let element = event.element {
    // of 연산자는 배열타입도 통짜로 방출합니다. [1, 2, 3, 4, 5] 배열이 있을때, from 처럼 각 원소 순차 방출이 아닌 배열 하나를 통짜로 방출
    print(element)
  }
}

// onNext 클로져를 통해 다음 방출하는 값을 확인할 수 있다.
observableOf2.subscribe(onNext: { element in
  print(element)
})

// 사용한 Observable은 적절하게 dispose 해줄 의무가 있다. lecture 11에서 알아보자.
