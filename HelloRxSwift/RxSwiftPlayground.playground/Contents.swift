import UIKit
import RxSwift
import RxCocoa

// MARK: - 17. BehaviorRelay
// * BehaviorReplay를 사용하기 위해서는 RxCocoa 라이브러리가 필요합니다.
// BehaviorRelay의 value 프로퍼티는 read-only 이므로 accept 메서드를 통해 값을 설정 할 수 있다.

let disposeBag = DisposeBag()
let relay = BehaviorRelay(value: "Initial Value")

relay.asObservable()
  .subscribe {
    print($0) // next(Initial Value)
  }

relay.accept("Secondary Value!!")

// BehaviorRelay에 배열값을 설정하는 방법
let relay2 = BehaviorRelay(value: [1])
// accept를 사용하면 이전의 값은 사라짐을 인지해야한다.
// 1) value 프로퍼티 + 새로 넣을 값을 추가하여 accept에 넣어준다.
relay2.accept(relay2.value + [2])
var relayValue = relay2.value
// 2) relay의 value 프로퍼티 값을 저장후, 변화시켰다가 변화시킨 값을 accept 하는 방법
relayValue.append(2)
relayValue.append(3)
relay2.accept(relayValue)

relay2.asObservable()
  .subscribe {
    print($0)
  }

// MARK: - 15. ReplaySubject
// ReplaySubject는 bufferSize를 갖습니다.
// 특정 bufferSize에 맞게 replay를 하고자 하는 경우, ReplaySubject를 유용하게 사용 가능합니다.

/*
let disposeBag = DisposeBag()
let subject = ReplaySubject<String>.create(bufferSize: 2)

subject.onNext("Issue 1")
subject.onNext("Issue 2")
subject.onNext("Issue 3")

subject.subscribe {
  print($0)
  // next(Issue 2)
  // next(Issue 3)
}

subject.onNext("Issue 4")
subject.onNext("Issue 5")
subject.onNext("Issue 6")

print("[Subscription 2]")
subject.subscribe {
  print($0)
}
 */


// MARK: - 14. Behavior Subjects
// BehaviorSubject는 PublishSubject와 달리 초기값을 갖고 있습니다.
// BehaviorSubject는 초기값을 갖고 있으므로 항상 이벤트를 출력하거나 줄 수 있습니다. 이때 전달하는 이벤트는 가장 마지막에 방출한 이벤트입니다.
/*
let disposeBag = DisposeBag()
let subject = BehaviorSubject(value: "Initial Value")

subject.onNext("Last Issue")

// 구독한 시점에서 Initial Value가 아닌 가장 마지막의 이벤트(Last Issue)를 출력합니다.
subject.subscribe { event in
  print(event)
}

subject.dispose()
subject.onCompleted()
subject.onNext("Issue 1") // onDisposed, onCompleted 이벤트 발생 전까지 구독한 이후의 이벤트도 출력이 된다.
*/

// MARK: - 13. Publish Subjects
/*
// publishSubject는 초기값이 존재하지 않아요.
// publishSubject는 값을 방출하는 Observable이면서, 이벤트를 감지하여 값을 보내는 Observer이기도 해요.
let disposeBag = DisposeBag()
let subject = PublishSubject<String>()
// 구독 전에 발생한 이벤트는 호출되지 않습니다.
subject.onNext("Issue 1")
// 구독 이전에 발생한 이벤트는 호출되지 않습니다.
subject.subscribe { event in
  print(event)
}

// 구독 후에 발생한 Issue 2는 출력됩니다.
subject.onNext("Issue 2")
subject.onNext("Issue 3")

// PublishSubject가 dispose 된 이후에 발생하는 이벤트는 무시됩니다.
subject.dispose()

subject.onNext("Issue 4")
subject.onCompleted()
 */

// MARK: - 12. What are Subjects?
// subject는 RxSwift 에서 중요한 개념 중 하나입니다. subject는 Observable이면서 Observer입니다.
// subject는 event를 받아서 그 결과를 subscriber들에게 전달합니다.
// subject의 종류로는 Behavior, Replay, Publish, BehaviroRelay 등이 있습니다.

// MARK: - 11. Disposing and Terminating
/*
// 사용한 Observable들에 대한 dispose 처리를 하지 않으면 memory leak을 야기할 수 있다.
// disposeBag은 subscription들에 대한 dispose를 할 책임을 갖고 있다.
// 각 subscription 하단에 disposed(by:)를 통해 disposeBag을 사용 가능합니다.
let disposeBag = DisposeBag()

let observableOf2 = Observable.of([1, 2, 3])
let observableFrom = Observable.from([1, 2, 3])
Observable.from(["A", "B", "C"]).subscribe {
  print($0)
}
.disposed(by: disposeBag)

// subscriptioinㅇDisposable 프로토콜을 채택하고 있다.
let subscriptionOf2 = observableFrom.subscribe(onNext: { element in
  print(element)
})

// subscription을 dispose하는 방법, 하지만 위와 같이 dispose 할 경우, 각각의 subscription에 대한 dispose를 깜빡할 수 있다.
subscriptionOf2.dispose()

// create를 통해 Observable에 대한 메서드 구현을 할 수 있다. next, completed 이벤트 등을 커스텀하게 구현할 수 있다.
Observable<String>.create { observer in
  observer.onNext("A") // "A"
  observer.onCompleted() // "onCompleted" -> "onDisposed"
  observer.onNext("?")
  // create를 사용하여 Observable을 생성할 경우 subscribe 클로져 내에서 Disposable타입을 반환해주어야 한다.
  // Disposables.create()는 Empty Disposable을 반환합니다.
  return Disposables.create()
}
.subscribe {
  // onNext 클로져 내의 value 반환
  print($0)
} onError: {
  // onError 클로져 내의 error 반환
  print($0)
} onCompleted: {
  // onCompleted 이벤트 클로져
  print("onCompleted")
} onDisposed: {
  // onDisposed 이벤트 클로져
  print("onDisposed")
}
.disposed(by: disposeBag)
*/


/*
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
*/
