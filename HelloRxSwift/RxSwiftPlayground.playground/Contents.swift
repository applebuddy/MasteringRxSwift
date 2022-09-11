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
