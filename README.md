# MasteringRxSwift
Study for Udemy Lecture, MasteringRxSwift
* lecture url (udemy) : https://www.udemy.com/course/mastering-rxswift-in-ios/learn/lecture/13577704#overview

<div>
<image width="500" src="https://user-images.githubusercontent.com/4410021/192058510-6028a135-1126-499f-ad58-24a1c26b1475.jpeg">

</div>



## Section 10. Beginning RxCocoa



### 61. concat operator

- concat(concatenate) operator는 두개의 sequence를 붙혀서 하나의 sequence로 반환한다.
  - combine concatenate operator와 유사

~~~swift
let disposeBag = DisposeBag()
let first = Observable.of(1, 2, 3)
let second = Observable.from([4, 5, 6])
let observable = Observable.concat([first, second])
observable.subscribe(onNext: {
  print($0) // 1, 2, 3, 4, 5, 6
})
~~~





### 62. merge operator

- merge operator는 time based diagram 순서(시간 순)에 맞게 합쳐진 상태의 시퀀스를 반환한다.  (concat operator처럼 앞 뒤 시퀀스를 단순하게 차례대로 붙히는 것이 아님)
  - combine merge operator와 유사

~~~swift
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
~~~





### 63. combineLatest operator

- combineLatest operator는 다수 Observable 각각의 최신 이벤트를 방출한다.
  - combine의 combineLatest와 동일

~~~swift
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
~~~



### 64. withLatestFrom operator

- withLatestFrom을 통해 특정 Observable 인자에 대한 최신 이벤트 값을 받을 수 있다.
  - ex) button이 withLatestFrom 인자로 특정 텍스트필드 Observable을 넣으면, button이 클릭될 때마다 텍스트필드의 최신 값을 감지할 수 있다.
  - combine의 switchToLatest와 살짝 유사한 역할이 있는 것 같다. 다만, combine에서는 publisher를 output으로 가진 subject에서 사용 가능, RxSwift에서는 단순 subject에서도 접근해서 사용 가능

~~~swift
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
~~~



### 65. reduce operator

- reduce operator는 초기값을 지정하고 Sequence에 대한 연산을 통해 하나의 결과 값으로 반환한다.
  - combine의 reduce와 유사

~~~swift
let disposeBag = DisposeBag()
let source = Observable.of(1, 2, 3)
source.reduce(0, accumulator: +) // 1 + 2 + 3 == 6
  .subscribe(onNext: {
    print($0) // 6
  }).disposed(by: disposeBag)

source.reduce(0, accumulator: { summary, value in
  return summary + value // accumulator 클로져를 통해 커스텀하게 연산이 가능하다. 위와 동일하게 모든 value의 합을 반환하는 연산이다.
}).subscribe(onNext: {
  print($0) // 6
}).disposed(by: disposeBag)
~~~



### 66. scan operator

- scan operator는 reduce operator와 친척같은(유사한) 형태의 연산자이다.
  - combine의 scan과 유사
- reduce는 Sequence 누적 연산의 마지막 결과 값만 반환하지만, scan은 그 연산 과정 결과도 함께 반환한다.

~~~swift
let disposeBag = DisposeBag()
let source = Observable.of(1, 2, 3, 4, 5)
source.scan(0, accumulator: +)
  .subscribe(onNext: {
    // 1, 3, 6, 10, 15 -> 마지막 결과 값, 15만 출력되는 reduce와 달리 scan operator는 중간 연산 과정도 함께 출력된다.
    print($0)
  }).disposed(by: disposeBag)
~~~



### 67. What is RxCocoa?

- RxCocoa는 많은 UIControl, 그 외 SDK 클래스 들에 대한 이벤트를 observable하게 관찰하고 binding하기 위한 커스텀 wrapper function을 제공한다.
- RxCocoa를 통해 기존 UI에 대한 Reactive한 접근이 가능하다. iOS, Apple Watch, Apple TV, macOS 등 다양한 플랫폼을 지원한다.
- RxCocoa example project에 사용되는 weather open api link
  - https://home.openweathermap.org

## Section 11. Error Handling

### 80. Managing Errors

- catchAndReturn : 에러 발생 시 지정된 특정 값을 전달
- retry : 에러 발생 시 재시도

## Section 12. MVVM with RxSwift

- MVC 패턴 : MVC, Model, ViewController로 구성되는 디자인패턴, 가장 구현난이도가 쉬워 진입장벽이 낮지만, ViewController의 역할이 커서 Messive ViewController, bad testability 의 문제점이 있다.
- MVVM패턴, View, ViewModel, Model로 구성되는 디자인패턴으로 MVC의 문제점을 해소하고, testabiliity를 개선할 수 있다.
- ViewModel에 비즈니스로직이 들어가며, ViewModel은 View와 Binding된다. 
  - Binding에는 RxSwift/RxCocoa, Combine을 사용할 수 있다.
  - SwiftUI의 경우 State, ObservableObject 등의 Propertywrapper를 사용하여 binding할 수도 있음
- Model, View는 서로 직접적으로 소통하지 않는다. ViewModel에서 복잡한 구조는 Model로 분리될 수 있다.
