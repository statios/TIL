# Transforming operators

### toArrary()

- next 이벤트 발생할 때마다 element를 저장해 두었다가 complete 되었을 때 배열로 만들어서 방출함 - complete 되기 전까지는 next 이벤트를 받지 않는다
- 즉 next 이벤트 때마다 기존 array 에 append 하는 것이 아니라 complete 되었을 때 array를 생성함

![Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image.png](Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image.png)

```swift
let disposeBag = DisposeBag()
Observable.of("a","b","c")
    .toArray()
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag) // a b c
let subject = PublishSubject<String>()
subject
    .toArray()
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
subject.onNext("a")
subject.onNext("b")
subject.onNext("c") // 아무일도 일어나지 않는다~
```

---

### map

- 방출된 element에 대해 연산을 수행한 후 리턴함

![Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%201.png](Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%201.png)

```swift
let disposeBag = DisposeBag()
Observable<Int>.of(1,2,3,4,5)
    .map { element -> Double in
        Double(Double(element)/10)
    }
    .subscribe { event in
        print(event)
    }
/*
next(0.1)
next(0.2)
next(0.3)
next(0.4)
next(0.5)
completed
*/
```

---

### enumerated()

element의 index를 제공한다

```swift
let disposeBag = DisposeBag()
Observable<Int>.of(1,2,3,4,5)
    .enumerated()
    .map { (index, element) -> Double in
        if index == 0 {
            return Double(100)
        } else {
            return Double(Double(element)/10)
        }
    }
    .subscribe { event in
        print(event)
    }
/*
next(100.0)
next(0.2)
next(0.3)
next(0.4)
next(0.5)
completed
*/
```

---

### Transforming inner observables - flatMap

- flatMap :
    - 방출 되는 element에 대해 각각 시퀀스를 생성하여 해당 element의 변화를 관찰한다
    - 즉 observable인 element를 받도록 해준다
    - 최종적으로 각각의 Observable<Element>는 하나로 결합된다
    - 바꾸어말하면 각각의 observable인 element를 계속 지켜본다

    ![Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%202.png](Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%202.png)

```swift
struct Student {
    let score: BehaviorSubject<Int>
}
let disposeBag = DisposeBag()
let laura = Student(score: BehaviorSubject(value: 80))
let charlotte = Student(score: BehaviorSubject(value: 90))
let student = PublishSubject<Student>()
student
    .flatMap {
        $0.score
    }
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
student.onNext(laura) //80
laura.score.onNext(85) //85
student.onNext(charlotte) //90
laura.score.onNext(95) //95
charlotte.score.onNext(100) //100
```

---

### flatMapLatest

- flatMap 처럼 방출되는 element에 대해 시퀀스를 생성하여 element의 변화를 관찰
- 각각의 observable인 element들에 대해 시퀀스는 유지하지만 최종적으로 이러한 각각의 시퀀스가 결합된 시퀀스는 가장 마지막의 observable<element>에 우선권이 주어진다.
- 그러니까 간단하게 말하면, 아래의 마블 그림에서 파랑시퀀스 - 초록 시퀀스 - 주황 시퀀스가 결합되었는데 결합된 시퀀스에서는 가장 최근의 시퀀스가 주황이라면 초록이나 파랑은 무시되고 주황의 시퀀스에서 방출되는 이벤트만을 받는다는 것

![Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%203.png](Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%203.png)

```swift
struct Student {
    let score: BehaviorSubject<Int>
}
let disposeBag = DisposeBag()
let ryan = Student(score: BehaviorSubject(value: 80))
let charlotte = Student(score: BehaviorSubject(value: 90))
let student = PublishSubject<Student>()
student
    .flatMapLatest {
        $0.score
    }
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
student.onNext(ryan) //80
ryan.score.onNext(85) //85
student.onNext(charlotte) //90
ryan.score.onNext(95) //무시됨
charlotte.score.onNext(100) //100
```

---

### Observing events - materialize

- next 이벤트에 next, complete, error 이벤트를 넣구 싶을 때
- Observable<<Event<Any>>>로 맵핑해줌

![Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%204.png](Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%204.png)

```swift
enum MyError: Error {
    case anError
}
struct Student {
    let score: BehaviorSubject<Int>
}
let disposeBag = DisposeBag()
let ryan = Student(score: BehaviorSubject(value: 80))
let charlotte = Student(score: BehaviorSubject(value: 100))
let student = BehaviorSubject(value: ryan)

let studentScore = student
    .flatMapLatest {
        $0.score
    }

studentScore
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag) // 80

ryan.score.onNext(85) // 85
ryan.score.onError(MyError.anError) // error(anError)
ryan.score.onNext(90) // nothing

student.onNext(charlotte) // nothng
```

```swift
enum MyError: Error {
    case anError
}
struct Student {
    let score: BehaviorSubject<Int>
}
let disposeBag = DisposeBag()
let ryan = Student(score: BehaviorSubject(value: 80))
let charlotte = Student(score: BehaviorSubject(value: 100))
let student = BehaviorSubject(value: ryan)

let studentScore = student
    .flatMapLatest {
        $0.score.materialize()
    }

studentScore
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag) // next(next(80))

ryan.score.onNext(85) // next(next(85))
ryan.score.onError(MyError.anError) // next(error(anError))
ryan.score.onNext(90) // nothing

student.onNext(charlotte) // next(next(100))
```

---

### Observing events - dematerialize

- Event<Any> → Any 로 변환해서 방출해줌

![Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%205.png](Transforming%20operators%200c8afeaba2e94970a936e13e2e28f3bf/image%205.png)

```swift
enum MyError: Error {
    case anError
}
struct Student {
    let score: BehaviorSubject<Int>
}
let disposeBag = DisposeBag()
let ryan = Student(score: BehaviorSubject(value: 80))
let charlotte = Student(score: BehaviorSubject(value: 100))
let student = BehaviorSubject(value: ryan)

let studentScore = student
    .flatMapLatest {
        $0.score.materialize()
    }

studentScore
    .filter({
        guard $0.error == nil else {
            print($0.error!)
            return false
        }
        return true
    })
    .dematerialize()
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag) // next(80)

ryan.score.onNext(85) // next(85)
ryan.score.onError(MyError.anError) // anError
ryan.score.onNext(90) // nothing

student.onNext(charlotte) // next(100)
```