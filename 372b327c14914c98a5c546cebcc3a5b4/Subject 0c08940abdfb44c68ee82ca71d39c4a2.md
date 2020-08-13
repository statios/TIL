# Subject

observable + subscribe

---

### basic

```swift
let subject = PublishSubject<String>()
    subject.onNext("hello?")// 구독전에 발생한 이벤트는 무시됨
let mySubscription = subject
    .subscribe(onNext: { str in
        print(str)
    })
subject.onNext("what?")// what?
```

---

### 여러가지 subjects

1. `PublishSubject` : 구독 이후의 이벤트만 처리
2. `BehaviorSubject` : 구독시점에 초기값을 가짐. 이후로 발생하는 이벤트를 수신
3. `ReplaySubject` : 버퍼를 두고 초기화. 버퍼 사이즈 만큼의 값들을 유지하면서 이후로 발생하는 이벤트를 수신

---

### PublishSubjects

구독 이후에 발생한 이벤트만 이용하려고 할 때

![Subject%200c08940abdfb44c68ee82ca71d39c4a2/image.png](Subject%200c08940abdfb44c68ee82ca71d39c4a2/image.png)

- 첫번째 줄은 subject, 나머지는 subscribe 시퀀스
- 위로 향하는 화살표는 구독, 아래로 향하는 화살표는 이벤트 방출
- subscribe 로 모든 종류의 event를 구독하는 경우 event.element는 옵셔널 - complete는 element가 없으므로
- subject가 종료된 이후에 구독을 하는 경우에는 종료 이벤트(complete, error)는 방출된다.
- 구독이후 + completed 되기전에 시퀀스를 dispose하는 경우 시퀀스 자체가 사라지므로 complete 이벤트를 받지 않는다

```swift
let subject = PublishSubject<String>()
subject.onNext("Is anyone listening?")
let subscriptionOne = subject
    .subscribe(onNext: { (string) in
        print(string)
    })
subject.on(.next("1"))
subject.onNext("2")

let subscriptionTwo = subject
    .subscribe({ (event) in
        print("2)", event.element ?? event)
    })
subject.onNext("3")
subscriptionOne.dispose()
subject.onNext("4")
subject.onCompleted()
subject.onNext("5"
subscriptionTwo.dispose()
let disposeBag = DisposeBag()
subject
    .subscribe {
        print("3)", $0.element ?? $0)
}
    .disposed(by: disposeBag)
subject.onNext("?")
/*
1
2
3
2) 3
2) 4
2) completed
3) completed
*/
```

---

### BehaviorSubjects

구독했을 때 가장 최근 이벤트를 초기 이벤트로 가지면서 구독 시작 - 초기값이 있어야 함

![Subject%200c08940abdfb44c68ee82ca71d39c4a2/image%201.png](Subject%200c08940abdfb44c68ee82ca71d39c4a2/image%201.png)

- subject 생성시 초기값을 입력하여 생성
- PublishSubject와 마찬가지로 구독 이전에 발생한 종료 이벤트를 구독과 동시에 받는다
- 뷰를 가장 최신의 데이터로 미리 채울때 사용
    - 유저정보를 갖고 있는 상태에서 유저 정보 화면으로 진입시 일단 기존의 데이터로 화면 뿌려주고 네트워크 완료되었을 때 유저정보를 업데이트 해주는 경우 등

```swift
enum MyError: Error {
    case anError
}
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}
let subject = BehaviorSubject(value: "Initial value")
let disposeBag = DisposeBag()
subject.onNext("X")
subject
    .subscribe{
        print(label: "1)", event: $0)
    }
    .disposed(by: disposeBag)
//    subject.onError(MyError.anError)
subject.onCompleted()
subject
    .subscribe {
        print(label: "2)", event: $0)
    }
    .disposed(by: disposeBag)
/*
1) X
1) Optional(completed)
2) Optional(completed)
*/
```

---

### ReplaySubjects

subject 생성시 지정한 크기가 2이라고 하자

구독 시점에서 최근 2 개만큼의 이벤트를 받으면서 구독을 시작한다

ReplaySubjects는 이벤트를 캐싱해서 2개만큼의 최근 이벤트를 계속 가지고 있는것

![Subject%200c08940abdfb44c68ee82ca71d39c4a2/image%202.png](Subject%200c08940abdfb44c68ee82ca71d39c4a2/image%202.png)

- 해당 버퍼는 메모리가 가지고 있으므로 element 사이즈나 버퍼 사이즈가 크다면 메모리 부하가 올 수도
- 종료 이벤트가 이미 발생한 ReplaySubject를 구독하는 경우
    - 버퍼된 event를 받고 종료 이벤트도 받는다
- subject를 dispose할 수가 있는데 이때 가지고 있던 버퍼가 제거되고, 구독중인 모든 시퀀스도 제거된다. - 다만 권장되지 않고 observer에서 dispose하는 것이 좋다
    - subject가 dispose되면 버퍼도 함께 제거된다
    - 따라서 이후에 구독한 옵저버는 버퍼된 이벤트는 받지 못하고 종료 이벤트만 받는다

```swift
let subject = ReplaySubject<String>.create(bufferSize: 2)
let disposeBag = DisposeBag()
subject.onNext("1")
subject.onNext("2")
subject.onNext("3")
subject
    .subscribe { event in
        print("observer 1 : \(event)")
    }
    .disposed(by: disposeBag)
subject
    .subscribe { event in
        print("observer 2 : \(event)")
    }
    .disposed(by: disposeBag)
subject.onNext("4")
subject.onCompleted()
subject
    .subscribe { event in
        print("observer 3 : \(event)")
    }
    .disposed(by: disposeBag)
/*
observer 1 : next(2)
observer 1 : next(3)
observer 2 : next(2)
observer 2 : next(3)
observer 1 : next(4)
observer 2 : next(4)
observer 1 : completed
observer 2 : completed
observer 3 : next(3)
observer 3 : next(4)
observer 3 : completed
*/
```

---

### BehaviorRelay (기존 variables)

- BehaviorSubject를 래핑함 → 가장 최근 element를 가지고 있고 구독시 방출함
- value라는 프로퍼티를 가진다
- value 프로퍼티에 초기값을 할당하고, accept에다가 value update를 해준당
- 이벤트의 개념이 아니라 value가 변할 때마다 기본적으로 next 이벤트에 element로 실어서 방출하는 느낌인것 같다
- 따라서 onNext, onError, onComplete로 이벤트를 발생시키는것이 아니라 value에 할당하면 그게 next이벤트로 전달된다.
- 단순 value 옵저빙 개념이므로 error이벤트는 존재하지 않는다
- 마찬가지로 complete 이벤트도 존재하지 않는다.
- 따라서 옵저버가 dispose() 될 때까지 계속 존재함

```swift
let variable = BehaviorRelay(value: "초기값")
let disposeBag = DisposeBag()
variable.accept("새로운 이벤트")
let subscription = variable.asObservable()
    .subscribe { event in
        print(event)
    }
variable.accept("구독 후에 한번 바꿔볼까")
subscription.dispose()
/*
next(새로운 이벤트)
next(구독 후에 한번 바꿔볼까)
*/
```

---

### PublishRelay

해당 문서를 잘 읽어보았다면 충분히 내용을 추론할 수 있을것이다. 미래의 너를 믿는다 기현. 쓰기 귀찮아서 그런것이 아니다.