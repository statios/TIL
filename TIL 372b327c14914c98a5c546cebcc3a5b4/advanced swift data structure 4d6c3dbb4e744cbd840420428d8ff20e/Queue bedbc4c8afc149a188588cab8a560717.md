# Queue

### 필수 메서드 지정

```swift
struct Queue<T> {
  
  private var data = [T]()
  
  init() { }
  
  mutating func dequeue() -> T? {
    return data.removeFirst()
  }
  
  func peek() -> T? {
    return data.first
  }
  
  //O(1)
  mutating func enqueue(element: T) {
    data.append(element)
  }
  
  mutating func clear() {
    data.removeAll()
  }
  
  var count: Int {
    return data.count
  }
  
  var capacity: Int {
    get {
      return data.capacity
    } set {
      data.reserveCapacity(newValue)
    }
  }
  
  func isFull() -> Bool {
    return count == data.capacity
  }
  
  func isEmpty() -> Bool {
    return data.isEmpty
  }
  
}
```

### ExpressibleByArrayLiteral 프로토콜 채택

배열 리터럴 문법의 초기화 구문을 제공한다.

```swift
extension Queue: ExpressibleByArrayLiteral {
  init(arrayLiteral elements: T...) {
    data = elements
  }
}
let ints = Queue(arrayLiteral: 1,2,3) //Queue<Int>
```

### 시퀀스 커스텀 이니셜라이져

시퀀스 타입으로 초기화할 수 있는 이니셜 라이저 정의

```swift
extension Queue {
  init<S: Sequence>(_ elements: S) where S.Iterator.Element == T {
    data.append(contentsOf: elements)
  }
}
let strs = Queue(["a", "b", "c"]) //Queue<String>
```

### QueueIterator 타입 정의

Queue가 Sequence를 채택하기 위해서 Iterator를 정의해준다

```swift
struct QueueIterator<T>: IteratorProtocol {
  var currentElements: [T]
  mutating func next() -> T? {
    if !self.currentElements.isEmpty {
      return currentElements.removeFirst()
    } else {
      return nil
    }
  }
}
```

### Sequence 프로토콜 채택

- for in 순환을 가능하게 한다
- IteratorProtocol을 채택한 Iterator가 필요

```swift
extension Queue: Sequence {
  func makeIterator() -> QueueIterator<T> {
    return QueueIterator(currentElements: self.data)
  }
}
```

```swift
let strs = Queue(["a", "b", "c"])
for str in strs {
  print(str)
}//a b c
```