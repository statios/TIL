# Filtering Operators

---

### ignoreElements()

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image.png)

- next 이벤트를 무시하는 오퍼레이터
- 종료 이벤트만 받음

```swift
let disposeBag = DisposeBag()
let subject = PublishSubject<String>()
subject
    .ignoreElements()
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
subject.onNext("X")
subject.onNext("X")
subject.onNext("X")
subject.onCompleted() 
// completed
```

---

### elementAt

- next 이벤트 중에서 n번째 방출된 이벤트만을 받는다 (나머지는 무시)
- n번째 이벤트를 받을때 종료 이벤트도 같이 받는다

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%201.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%201.png)

```swift
let disposeBag = DisposeBag()
let subject = PublishSubject<String>()
subject
    .elementAt(2)
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
subject.onNext("element 1")
subject.onNext("element 2")
subject.onNext("element 3")
/*
next(element 3)
completed 
*/
```

---

### filter

- condition을 만족하는 element 만 받는다

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%202.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%202.png)

```swift
let disposeBag = DisposeBag()
Observable.of(1,2,3,4,5,6)
    .filter { integer -> Bool in
        integer % 2 == 0
    }
    .subscribe(onNext: { element in
        print(element)
    })
    .disposed(by: disposeBag)
// 2 4 6
```

---

### skip

- 전달 받은 이벤트 중에 첫번째 부터 n 개의 element를 건너뛴다

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%203.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%203.png)

```swift
let disposeBag = DisposeBag()
Observable.of("가","나","다","라","마","바","사","너와나의암호말")
    .skip(3)
    .subscribe(onNext: { element in
        print(element)
    })
    .disposed(by: disposeBag)
//라 마 바 사 너와나의암호말
```

---

### skipWhile

- condition을 만족하지 않는 element가 나올때까지 이벤트 방출을 건너뜀

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%204.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%204.png)

```swift
let disposeBag = DisposeBag()
Observable.of(2,3,5,2,7,7,6)
    .skipWhile { element -> Bool in
        element % 2 == 0
    }
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
/*
next(3)
next(5)
next(2)
next(7)
next(7)
next(6)
completed
*/
```

---

### skipUntil

- 지정된 다른 옵저버블이 next 이벤트를 방출할 때까지 기존 옵저버블의 이벤트 방출을 무시함

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%205.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%205.png)

```swift
let disposeBag = DisposeBag()
let mySubject = PublishSubject<String>()
let triggerSubject = PublishSubject<String>()
mySubject
    .skipUntil(triggerSubject)
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
mySubject.onNext("A")
mySubject.onNext("B")
triggerSubject.onNext("Let's start!")
mySubject.onNext("C?")
//next(C?)
```

---

### take(_:n)

- n개의 이벤트만 받는다
- n번째 이벤트를 받을때 종료 이벤트도 함께 받는다

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%206.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%206.png)

```swift
let disposeBag = DisposeBag()
Observable.of(1,2,3,4,5,6)
    .take(2)
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
/*
next(1)
next(2)
completed
*/
```

---

### takeWhile(_:n)

- condition이 false일 때까지만 이벤트를 받는다
- condition이 false인 이벤트가 발생하면 종료이벤트를 발생한다

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%207.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%207.png)

```swift
let disposeBag = DisposeBag()
Observable.of(1,2,3,4,5,6)
    .takeWhile({ element -> Bool in
        element <= 3
    })
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
/*
next(1)
next(2)
next(3)
completed
*/
```

---

### takeUntil(_otherObservable:Observable)

- 지정된 다른 옵저버블이 next 이벤트를 발생하면 해당 옵저버블은 종료 이벤트를 발생한다

    = 지정된 다른 옵저버블이 next 이벤트를 발생할때까지만 이벤트를 받는다

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%208.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%208.png)

```swift
let disposeBag = DisposeBag()
let triggerSubject = PublishSubject<String>()
let mySubject = PublishSubject<String>()
mySubject
    .takeUntil(triggerSubject)
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
mySubject.onNext("동해물과")
mySubject.onNext("백두산이")
triggerSubject.onNext("이제그만")
mySubject.onNext("마르고닳도록")
/*
next(동해물과)
next(백두산이)
completed
*/
```

---

### distinctUntilChanged()

- 마지막 element와 현재 element가 다를 때만 element를 받는다

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%209.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%209.png)

```swift
let disposeBag = DisposeBag()
Observable.of(1,1,2,2,1)
    .distinctUntilChanged()
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
// 1 2 1
```

---

### distinctUntilChanged(_:)

- 직전 element와 새로운 element에 대해 condition이 false 일 때만 새로운 element를 받는다

![Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%2010.png](Filtering%20Operators%204f8ebc67d7ad4950b410e91af1bd0632/image%2010.png)

```swift
let disposeBag = DisposeBag()
Observable.of(10,20,30,50,40,50)
    .distinctUntilChanged { (previousElement, currentElement) -> Bool in
        previousElement + 10 == currentElement
    }
    .subscribe { event in
        print(event)
    }
    .disposed(by: disposeBag)
/*
next(10)
next(30)
next(50)
next(40)
completed
*/
```

---