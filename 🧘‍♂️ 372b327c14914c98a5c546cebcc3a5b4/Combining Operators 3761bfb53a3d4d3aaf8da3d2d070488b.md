# Combining Operators

### startwith(_:)

- 앞에 붙이기

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image.png)

```swift
let numbers = Observable.of(2, 3, 4)
let observable = numbers.startWith(1)
observable.subscribe { event in
    print(event)
} /*
next(1)
next(2)
next(3)
next(4)
completed 
*/
```

---

### Observable.concat(_:)

- 여러 시퀀스를 합친다
- 각 시퀀스는 당연히~ 순서를 가지며 이전 시퀀스가 종료 이벤트를 방출했을 때 비로소 다음 시퀀스를 구독
- 중간에 에러 이벤트가 방출되면 concat된 시퀀스도 에러 이벤트를 방출하며 종료됨

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%201.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%201.png)

```swift
let disposeBag = DisposeBag()
let first = Observable.of(1, 2, 3)
let second = Observable.of(4, 5, 6)
let observable = Observable.concat([first, second])
observable.subscribe { event in
    print(event)
}
/*
 next(1)
 next(2)
 next(3)
 next(4)
 next(5)
 next(6)
 completed
 */
```

---

### concat(_:)

```swift
let germanCities = Observable.of("Berlin", "Munich", "Frankfurt")
let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
let observable = germanCities.concat(spanishCities)
observable.subscribe { event in
    print(event)
}
/*
 next(Berlin)
 next(Munich)
 next(Frankfurt)
 next(Madrid)
 next(Barcelona)
 next(Valencia)
 completed
 */
```

---

### concatMap()

- 각각의 event.element에 대한 sequence를 생성하여 합쳐진다
- 이전 sequence가 종료되었을 때 다음 시퀀스를 시작한다 - 각 event.element sequence의 순서를 보장

```swift
let sequence = [
    "German cities": Observable.of("Berlin", "Munich", "Valencia"),
    "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")
]
let observable = Observable.of("German cities", "Spanish cities")
    .concatMap ({ country in sequence[country] ?? .empty() })
    .subscribe { event in print(event) }
/*
 next(Berlin)
 next(Munich)
 next(Valencia)
 next(Madrid)
 next(Barcelona)
 next(Valencia)
 completed
 */
```

---

### merge()

- 두개 이상의 sequence에 대해 merge 시퀀스를 생성한다
- 관찰 중인 시퀀스가 event를 발생하면 merged sequence에서도 해당 event를 emit
- 어떤 sequence에서 전달된 event인지를 상관하지 않고 전달된 순서대로 merged sequence에서 이벤트를 emit
- 관찰 중인 sequence가 모두 종료되면 merged sequence도 종료됨

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%202.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%202.png)

```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()
let mid = PublishSubject<String>()
let source = Observable.of(left.asObservable(), right.asObservable())
let observable = source.merge()
let disposable = observable.subscribe { event in
    print(event)
}
var leftValues = ["A","B","C"]
var rightValues = ["a", "b", "c"]

repeat {
    switch Bool.random() {
    case true where !leftValues.isEmpty:
        left.onNext("Left: " + leftValues.removeFirst())
    case false where !rightValues.isEmpty:
        right.onNext("Right: " + rightValues.removeFirst())
    default:
        break
    }
} while !leftValues.isEmpty || !rightValues.isEmpty

left.onCompleted()
right.onCompleted()

disposable.dispose()
/*
 next(Left: A)
 next(Right: a)
 next(Right: b)
 next(Right: c)
 next(Left: B)
 next(Left: C)
 completed
*/
```

---

### merge(maxConcurrent:)

- maxConcurrent(Int) 만큼의 시퀀스만을 merge

---

### combineLatest(::resultSelector)

- 관찰 중인 여러 시퀀스로부터 이벤트를 받아서 combined sequence에서 방출
- 각 시퀀스의 가장 최근 element와 결합한다
- last event가 없으면 combined event를 발생하지 않는다

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%203.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%203.png)

```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()

let observable = Observable.combineLatest(left, right) { (lastLeft, lastRight) in
    "\(lastLeft) \(lastRight)"
}
let disposable = observable.subscribe { event in
    print(event)
}
left.onNext("a")
right.onNext("A")
right.onNext("B")
left.onNext("b")
right.onNext("C")
left.onNext("c")

disposable.dispose()
/*
 next(a A)
 next(a B)
 next(b B)
 next(b C)
 next(c C)
*/
```

```swift
let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
let dates = Observable.of(Date())
let observable = Observable.combineLatest(choice, dates) { (format, when) -> String in
    let formatter = DateFormatter()
    formatter.dateStyle = format
    return formatter.string(from: when)
}
observable.subscribe { event in
    print(event)
}
/*
 next(5/11/20)
 next(May 11, 2020)
 completed

 */
```

---

### combinLatest(collection, resultSelector:)

- a시퀀스와 b시퀀스의 last 이벤트를 결합하여 array로 뿜어준다

```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()
let observable = Observable.combineLatest([left, right]) { strings in
    strings.joined(separator: ">")
}
let disposable = observable.subscribe { event in
    print(event)
}
left.onNext("a")
right.onNext("A")
right.onNext("B")
left.onNext("b")
right.onNext("C")
left.onNext("c")
disposable.dispose()
/*
 next(a>A)
 next(a>B)
 next(b>B)
 next(b>C)
 next(c>C)
 */
```

---

### zip

- 여러 시퀀스에서 보내는 이벤트를 받아서 zipped sequence를 만든다
- 각 시퀀스에서 받는 element의 index는 동일해야 한다
    - a 시퀀스 n번째 요소 - zip - b 시퀀스 n번째 요소
- 항상 짝을 이루어야 하므로 관찰중인 시퀀스 중에 어느 하나만 종료되어도 zipped sequence도 종료됨

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%204.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%204.png)

```swift
enum Wheather {
    case cloudy
    case sunny
}
let disposeBag = DisposeBag()
let left: Observable<Wheather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
let right = Observable.of("서울","대전","대구","부산","광주")
let observable = Observable.zip(left, right) { (wheather, city) in
    return "\(city) 날씨는 \(wheather)"
}
observable
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
/*
 next(서울 날씨는 sunny)
 next(대전 날씨는 cloudy)
 next(대구 날씨는 cloudy)
 next(부산 날씨는 sunny)
 completed
 */
```

---

### withLatestFrom(_:)

- 파라미터로 받은 sequence에서 마지막으로 발생한 event를 받아온다

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%205.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%205.png)

```swift
let button = PublishSubject<Void>()
let textField = PublishSubject<String>()

let observable = button
    .withLatestFrom(textField)
    .subscribe({ event in print(event) })

textField.onNext("Se")
textField.onNext("Seou")
textField.onNext("Seoul")
button.onNext(())
button.onNext(())
/*
 next(Seoul)
 next(Seoul)
 */
```

---

### sample(_:)

- 파라미터로 받은 sequence에서 이벤트가 발생했을 때 자기 자신의 시퀀스에서 가장 최신의 이벤트를 한번만 받는다
- 하지만 최신의 element가 이전과 다르다면 이벤트를 수신한다
    - 마블 그림에서 textField가 next(Paris!)를 방출하고
    - button에서 next() 되었다면 textfield.smaple(button)에서는 Paris!를 수신한다

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%206.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%206.png)

```swift
let button = PublishSubject<Void>()
let textField = PublishSubject<String>()
let observable = textField
    .sample(button)
    .subscribe { event in print(event) }
textField.onNext("Se")
textField.onNext("Seou")
button.onNext(())
textField.onNext("Seoul!")
button.onNext(())
button.onNext(())
button.onNext(())
/*
 next(Seou)
 next(Seoul!)
 */
```

```swift
//이렇게 하면 sample 이랑 똑같다
let button = PublishSubject<Void>()
let textField = PublishSubject<String>()
let observable = button
    .withLatestFrom(textField)
    .distinctUntilChanged()
    .subscribe { event in
        print(event)
    }
textField.onNext("Se")
textField.onNext("Seou")
button.onNext(())
textField.onNext("Seoul!")
button.onNext(())
button.onNext(())
button.onNext(())
/*
 next(Seou)
 next(Seoul!)
```

---

### amb(_:)

- 두가지 sequence의 이벤트 중 먼저 발생한 시퀀스만을 받는다.
- `left.amb(right)` - left, right 모두 구독하고 있다가 right 에서 이벤트를 먼저 발생했으므로 left 시퀀스의 구독을 중단하고 right 시퀀스의 이벤트만을 받는다

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%207.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%207.png)

```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()

let observable = left
    .amb(right)
    .subscribe { event in
        print(event)
    }

right.onNext("A")
left.onNext("a")
left.onNext("b")
left.onNext("c")
right.onNext("B")

left.onCompleted()
right.onCompleted()
```

---

### switchLatest()

- 마지막으로 구독한 시퀀스의 이벤트만 받는다

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%208.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%208.png)

```swift
let one = PublishSubject<String>()
let two = PublishSubject<String>()
let three = PublishSubject<String>()
let source = PublishSubject<Observable<String>>()
let observable = source.switchLatest()
observable
    .subscribe { event in print(event) }
source.onNext(one)
one.onNext("Sequence 1-1")
two.onNext("Sequence 2-1") //x

source.onNext(two)
two.onNext("Sequence 2-2")
one.onNext("Sequence 1-2") //x

source.onNext(three)
two.onNext("Sequence 2-3") //x
one.onNext("Sequence 1-3") //x
three.onNext("Sequence 3-1")

source.onNext(one)
one.onNext("Sequence 1-4")
/*
 next(Sequence 1-1)
 next(Sequence 2-2)
 next(Sequence 3-1)
 next(Sequence 1-4)
 */
```

---

### reduce

- 종료 이벤트 발생할 때까지 재귀 수행

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%209.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%209.png)

```swift
let source = Observable.of(1,3,5,7,9)
source
    .reduce(0, accumulator: +)
    .subscribe { event in print(event) }
/*
next(25)
completed
*/
```

---

### scan

- 매 이벤트마다 재귀를 수행한다.

![Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%2010.png](Combining%20Operators%203761bfb53a3d4d3aaf8da3d2d070488b/image%2010.png)

```swift
let source = Observable.of(1,3,5,7,9)
source.scan(0, accumulator: +)
    .subscribe { event in print(event) }
/*
 next(1)
 next(4)
 next(9)
 next(16)
 next(25)
 completed
 */
```