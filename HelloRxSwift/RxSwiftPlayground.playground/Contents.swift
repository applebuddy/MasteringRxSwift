import UIKit
import RxSwift
import RxCocoa

// MARK: 64: withLatestFrom operator
// withLatestFrom을 통해 특정 OBservable 인자에 대한 최신 이벤트값을 받을 수 있다.
// ex) button이 withLatestFrom 인자로 특정 텍스트필드 Observable을 넣으면, button이 클릭될 때마다 텍스트필드의 최신 값을 감지할 수 있다.
let disposeBag = DisposeBag()
let button = PublishSubject<Void>()
let textField = PublishSubject<String>()
let observable = button.withLatestFrom(textField)
let disposable = observable.subscribe(onNext: {
  print($0)
})

textField.onNext("Sw")
textField.onNext("Swif")
textField.onNext("Swift") // 버튼이 클릭되기 전까지는 구독한 observable의 이벤트가 방출되지 않는다.

// button subject가 Void 이벤트를 방출할때마다(클릭할때마다) 구독한 observable을 통해 클릭 직후의 텍스트필드 최신 이벤트를 받을 수 있다.
button.onNext(()) // -> Swift
button.onNext(()) // -> Swift

// MARK: 63. combineLatest operator
// combineLatest operator는 다수 Observable 각각의 최신 이벤트를 방출한다.
/*
let disposeBag = DisposeBag()
let left = PublishSubject<Int>()
let right = PublishSubject<Int>()
let observable = Observable.combineLatest(left, right, resultSelector: { lastLeft, lastRight in
  "left : \(lastLeft), right : \(lastRight)"
})

let disposable = observable.subscribe(onNext: { value in
  print(value)
})
// combineLatest는 Observable의 최신상태 이벤트를 방출할때 사용한다. 텍스트필드 유효성 검사 등에 사용할 수 있다.
left.onNext(1)
right.onNext(3) // left : 1, right : 3
left.onNext(2) // left : 2, right : 3
right.onNext(100) // left : 2, right : 100
right.onNext(200) // left : 2, right : 200
left.onNext(300) // left : 300, right : 200
 */

// MARK: 62. merge operator
// merge operator는 time based diagram 순서에 맞게 합쳐진 상태의 시퀀스를 반환한다. (concat operator처럼 앞 뒤 시퀀스를 차례대로 붙이는것이 아님)
/*
let disposeBag = DisposeBag()
let left = PublishSubject<Int>()
let right = PublishSubject<Int>()
// left, right PublishSubject<Int>를 각각 Observable<Int>로 변환(asObservable())하여 of 연산자 인자로 넣었다.
let source = Observable.of(left.asObservable(), right.asObservable())
// left, right subject를 merge하여 left, right가 이벤트를 방출하는 시간 순으로 이벤트를 감지할 수 있다.
let observable = source.merge()
observable.subscribe(onNext: {
  print($0)
}).disposed(by: disposeBag)

// left, right subject가 이벤트를 방출하는 time 순으로 이벤트가 방출된다.
left.onNext(10)
left.onNext(20)
right.onNext(30)
right.onNext(40)
left.onNext(50)
 */

// MARK: 61. concat operator
// concat(concatenate) operator는 두개의 sequence를 붙여서 하나의 sequence로 반환합니다.
/*
let disposeBag = DisposeBag()
let first = Observable.of(1, 2, 3)
let second = Observable.from([4, 5, 6])
let observable = Observable.concat([first, second])
observable.subscribe(onNext: {
  print($0) // 1, 2, 3, 4, 5, 6
})
 */

// MARK: - Section 9
// MARK: 60. startWith operator
// startWith operator는 시퀀스 Observable을 특정 값으로 시작하는 시퀀스 Observable로 반환합니다.
/*
let disposeBag = DisposeBag()
let numbers = Observable.from([2, 3, 4])

let observable = numbers.startWith(100) // 100부터 시작하는 Observable<Int>이 된다.
observable.subscribe(onNext: {
  print($0) // 100, 2, 3, 4
}).disposed(by: disposeBag)
*/

// MARK: 49~50. flatMap, flatMapLatest Operator
// flatMap은 map 연산자와 유사한 연산자인데 다만 반환타입이 다릅니다.
// flatMap은 map을 적용한 Observable들을 모두 합쳐서 하나의 Observable로 반환합니다.
// 따라서 연산작업을 한 후 마지막에 subscribe하여 Reactive 하게 처리를 하고자 할때 유용하다.

// flatMapLatest는 가장 마지막의 latest Observable을 반환한다.
/*
let disposeBag = DisposeBag()
struct Student {
  var score: BehaviorRelay<Int>
}

let john = Student(score: BehaviorRelay(value: 75))
let mary = Student(score: BehaviorRelay(value: 90))
let student = PublishSubject<Student>()
let student2 = PublishSubject<Student>()

let map = student // PublishSubject<Student>
  .asObservable() // Observable<Student>
  .map { $0.score.asObservable() } // Observable<Observable<Int>> -> map 연산자를 사용하는 경우, 이대로 subscribe 할 경우 정상적으로 값을 구독하여 감지할 수 없다.
let flatMap = student.asObservable() // Observable<Student>
  .flatMap { $0.score.asObservable() } // Observable<Int> -> flatMap을 사용하면 Observable<Int>로 변환되어 subscribe 할 시, score 값을 구독 감지할 수 있다.
// flatMap example)
/*
student.asObservable()
  .flatMap { $0.score.asObservable() }
  .subscribe(onNext: {
    print($0)
  })

student.onNext(john)
john.score.accept(95)

student.onNext(mary)
mary.score.accept(85)
john.score.accept(55)
*/

// flatMapLatest example)
/*
student2.asObservable()
  .flatMapLatest { $0.score.asObservable() }
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)

student2.onNext(john) // john에 대한 이벤트만 방출함
john.score.accept(100) // -> 가장 최근에 감지한 Observable은 john이므로 이벤트를 방출함
// flatMapLatest를 사용하면 가장 마지막으로 감지한 Observable의 이벤트만 방출한다.
student2.onNext(mary) // mary에 대한 이벤트만 방출함
// 가장 최근에 감지한 Observable은 mary이므로, student2에서 john Observable에 대한 이벤트는 방출하지 않는다.
john.score.accept(0) // -> student2에서 이벤트 방출하지 않음
// 가장 최근에 감지한 Observable은 mary이므로 student2로부터 mary의 이벤트는 방출된다.
mary.score.accept(95) // -> student2에서 이벤트 방출함. mary는 가장 최근에 감지한 Observable이기 때문
// 이처럼, flatMap과 달리, flatMapLatest는 가장 최근의 Observable에 대한 이벤트만 감지하고 방출할때 사용할 수 있다.
*/
*/

// MARK: 48. map Operator
// 현재 Sequence의 각 element들에 대해서 특정 연산을 한 새로운 Sequence로 변환할때 사용한다.
/*
let disposeBag = DisposeBag()
Observable.of(1, 2, 3, 4, 5)
  .map { $0 * 2 } // 각각의 값을 2배 연산한 Sequence로 맵핑
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)
 */


// MARK: - Section 7. Transforming Operators
// MARK: 47. To Array Operator
/*
let disposeBag = DisposeBag()
Observable.of(1, 2, 3, 4, 5)
  .toArray() // Single<[Int]>
  .asObservable() // Observable<[Int]>>
  .subscribe(onNext: {
    // toArray()는 Single Observable이벤트를 방출한다.
    print($0)
  }).disposed(by: disposeBag)

Observable.of(1, 2, 3, 4, 5)
  .filter { $0 % 2 == 0 }
  .subscribe(onNext: {
    print($0)
  }).disposed(by: disposeBag)
 */

// MARK: 36. TakeUntil Operator
// trigger subject가 trigger하기 전까지 값을 방출한다.
/*
let disposeBag = DisposeBag()
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()
subject
  .take(until: trigger)
  .subscribe(onNext: { value in
    print(value)
  })
  .disposed(by: disposeBag)
// trigger subject가 trigger하기 전까지 이벤트를 방출합니다.
subject.onNext("A")
subject.onNext("B")
subject.onNext("C")
// trigger sugject가 값을 방출한 이후의 값은 방출되지 않고 무시됩니다.
trigger.onNext("triggered")
subject.onNext("D")
 */

// MARK: 35. TakeWhile Operator
// 지정한 조건 충족이 되지 않는 시점까지 조건 충족을 한 이벤트를 방출한다.
/*
let disposeBag = DisposeBag()
Observable.of(1, 1, 3, 3, 4, 4, 5, 6)
  .take(while: { $0 % 2 == 1 }) // 짝수가 나오기 전까지의 값이 방출된다. 이후의 값은 무시된다.
  .subscribe(onNext: { value in
    print(value) // 짝수가 나오기 전인 1, 1, 3, 3 값이 방출된다.
  })
  .disposed(by: disposeBag)
*/

// MARK: 34. Take Operator
// 첫 N개의 이벤트를 방출한다.
/*
let disposeBag = DisposeBag()
Observable.of(1, 2, 3, 3, 4, 5, 6)
  .take(3) // 처음 3개의 이벤트를 방출한다.
  .subscribe(onNext: {
    print($0) // 1, 2, 3 이후 4번째 부터는 이벤트가 방출되지 않고 무시된다.
  })
  .disposed(by: disposeBag)
 */

// MARK: 33. SkipUntil Operator
// skipUntil Operator는 trigger subject가 trigger하기 전까지 이벤트를 방출하지 않고 skip한다.
/*
let disposeBag = DisposeBag()
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()
subject.skip(until: trigger)
  .subscribe(onNext: {
    print($0)
  })
  .disposed(by: disposeBag)
// trigger subject가 이벤트 방출하기 전까지 subject subject의 이벤트는 skip된다.
// trigger subject가 이벤트를 방출하기 전까지 subject에서 값은 방출되지 않고 skip된다.
subject.onNext("A")
subject.onNext("B")

// trigger subject가 이벤트를 방출한 이후 subject에서 이벤트가 방출된다.
trigger.onNext("X")
subject.onNext("C")
 */

// MARK: 32. SkipWhile Operator
// 최초 조건 충족이 되지 않을때까지 이벤트를 Skip할 수 있도록 해주는 Operator, skipWhile 조건에 해당되지 않는 시점부터 이벤트가 방출된다.
/*
let disposeBag = DisposeBag()
Observable.of(2, 2, 3, 4, 4, 4)
  .skip(while: { $0 % 2 == 0 }) // 홀수가 나오기 전까지 짝수인 값들을 skip된다.
  .subscribe(onNext: { value in
    print(value) // 초기 2, 2는 짝수이므로 skip된다. 이후 3이라는 홀수가 나오면서 이후 값은 방출된다.
  })
  .disposed(by: disposeBag)
 */

// MARK: 31. Skip Operator
/*
let disposeBag = DisposeBag()
Observable.of("A", "B", "C", "D", "E", "F")
  .skip(3) // 3번째 값 까지는 skip한다.
  .subscribe(onNext: {
    print($0) // A, B, C는 skip되고 이후 D, E, F 값이 방출된다.
  })
  .disposed(by: disposeBag)
 */

// MARK: 30. Filter Operator
// 특정 조건을 충족하는 이벤트만 필터링하여 방출할때 사용
/*
let disposeBag = DisposeBag()
Observable.of(1, 2, 3, 4, 5, 6, 7)
  .filter { $0 % 2 == 0 } // 짝수 값만 방출되도록 필터링
  .subscribe { value in
    print(value) // 2, 4, 6, completed 이벤트가 방출
  }
  .disposed(by: disposeBag)
 */

// MARK: 29. Element At Operator
// based on 0 인덱스로 N번째 이벤트를 방출할때 사용한다.
/*
let strikes = PublishSubject<String>()
let disposeBag = DisposeBag()

strikes.element(at: 2)
  .subscribe(onNext: { value in
    print("You are out!, value : \(value)")
  }).disposed(by: disposeBag)

strikes.onNext("X") // 0번째 element
strikes.onNext("X") // 1번째 element
strikes.onNext("O") // 2번째 element -> 이벤트 발생
 */

// MARK: - Section 5. Filtering Operators
// MARK: 28. Ignore Operator
/*
// 초기값을 갖지않는 PublishSubject, strikes
let strikes = PublishSubject<String>()
let disposeBag = DisposeBag()

strikes
  .ignoreElements()
  .subscribe { _ in
    // 구독을 해도 ignoreElements() Operator를 사용하여 이벤트가 방출 되지 않고, onCompleted 될 때만 호출된다.
    print("[Subscription is called]")
  }
  .disposed(by: disposeBag)

strikes.onNext("A") // ignored
strikes.onNext("B") // ignored
strikes.onNext("C") // ignored
strikes.onCompleted() // called : [Subscription is called]
*/

// MARK: Section 4. Implementing Photo Filter App Using RxSwift
// MARK: - 18. What we wiill be building?
// ...

// MARK: Section 3
// MARK: - 17. BehaviorRelay
// * BehaviorReplay를 사용하기 위해서는 RxCocoa 라이브러리가 필요합니다.
// BehaviorRelay의 value 프로퍼티는 read-only 이므로 accept 메서드를 통해 값을 설정 할 수 있다.
/*
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
 */

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
