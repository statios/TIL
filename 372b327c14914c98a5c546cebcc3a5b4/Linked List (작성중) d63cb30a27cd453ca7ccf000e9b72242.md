# Linked List (작성중)

- What is Linked list? 단방향 선형 시퀀스로 정렬된 값들의 집합
    - 단방향 : values 사이의 관계 방향이 한쪽 밖에 없다
    - 선형 : 꼬리가 대가리를 물지 않는다. 즉 시작점과 끝이 존재함.
- What is the advantages?
    - lnsertion and removal from the front of the list - O(1) 시간복잡도
    - 퍼포먼트 특징을 신뢰할 수 있다
- 링크드 리스트는 노드의 연결로 구성되어 있는데 노드의 역할은
    - 자체 value를 가짐
    - 다음 node를 참조함 - 다음 node의 참조값이 nil이면 해당 value는 end of list

    ![Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image.png](Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image.png)

---

### Node

```swift
public class Node<Value> { // 노드 객체 정의
  public var value: Value // 노드는 value를 가짐 (제네릭 타입)
  public var next: Node? // if next == nil then this node is last
  
  public init(value: Value, next: Node? = nil) {
    self.value = value
    self.next = next
  }
}

extension Node: CustomStringConvertible { // 노드를 프린트 했을때 찍히는 문자열을 커스텀함
  public var description: String {
    guard let next = next else {
      return "\(value)"
    }
    return "\(value) -> " + String(describing: next) + " "
  }
}

let node1 = Node(value: 1)
let node2 = Node(value: 2)
let node3 = Node(value: 3)

node1.next = node2
node2.next = node3

print(node1) // 1 -> 2 -> 3
```

---

### LinkedList

![Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image%201.png](Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image%201.png)

- linkedList 객체는 head와 tail을 가진다
- head : 첫번째 노드
- tail : 마지막 노드

```swift
public struct LinkedList<Value> {
  public var head: Node<Value>?
  public var tail: Node<Value>?
  public init() {}
  public var isEmpty: Bool {
    head == nil
  }
}

extension LinkedList: CustomStringConvertible {
  public var description: String {
    guard let head = head else {
      return "Empty list"
    }
    return String(describing: head)
  }
}
```

---

### 리스트에 values를 추가해 보자

linked list에 value를 추가하는 방법

1. push : 링크드 리스트의 가장 앞에 값을 추가함
2. append : 링크드 리스트의 마지막에 값을 추가함
3. insert(after:) : 특정 노드 뒤에 값을 삽입함

---

### push

- 링크드리스트의 맨 앞에 노드를 추가하는 오퍼레이터
- head-first insertion 이라고도 한다

```swift
extension LinkedList {
  public mutating func push(_ value: Value) {
    head = Node(value: value, next: head)
    if tail == nil {
      tail = head
    }
  }
}
```

- tail == nil 인 경우 LinkedList는 empty이고 이때는 push하는 노드가 head 이면서 tail이 된다.

```swift
var list = LinkedList<Int>()
list.push(3)
list.push(2)
list.push(1)
print(list) //1 -> 2 -> 3
```

---

### append

- 링크드리스트의 맨 뒤에 노드를 추가하는 오퍼레이터
- tail-end insertion 이라고도 한다

```swift
extension LinkedList {
  public mutating func append(_ value: Value) {
    
    guard !isEmpty else { //list가 empty인 경우
      push(value) // push(value)를 수행하고
      return // 함수 종료
    }
    
    // list가 empty가 아닌 경우
    tail!.next = Node(value: value) // empty가 아니므로 tail 강제언래핑 -> tail.next 노드로 새로운 노드 할당
    tail = tail!.next // 새로운 노드를 tail 노드로 지정
  }
}
```

```swift
var list = LinkedList<Int>()
list.append(1)
list.append(2)
list.append(3)
print(list) //1 -> 2 -> 3
```

---

### insert(after:)

- list의 특정 위치에 새로운 노드를 삽입한다
- 동작 순서
    1. 삽입하려는 특정 노드의 위치를 찾는다
    2. 새로운 노드를 삽입한다

먼저 특정 노드의 위치를 찾는 메서드이다.

```swift
extension LinkedList {
  public mutating func node(at index: Int) -> Node<Value>? {
    var currentNode = head // 헤드 노드를 복사함
    var currentIndex = 0 // 초기 인덱스를 지정함
    while currentNode != nil && currentIndex < index {
      currentNode = currentNode!.next
      currentIndex += 1
    }
    return currentNode
  }
}
```

원하는 인덱스까지 도달할때까지 currentNode를 대치해가면서 특정 노드를 찾아낸다.

empty list이거나 out-of-bounds index인 경우 nil을 리턴한다

다음은 특정 위치에 새로운 노드를 삽입하는 메서드이다.

```swift
extension LinkedList {
	//1
  @discardableResult
  public mutating func insert(
    _ value: Value,
    after node: Node<Value>
  ) -> Node<Value> {
		//2
    guard tail !== node else {
      append(value)
      return tail!
    }
		//3
    node.next = Node(value: value, next: node.next)
    return node.next!

  }
}
```

1. discardableResult : return 값을 사용하지 않을 수도 있는 메서드란 말이다 - 워닝 안뜨게함
2. 레퍼런스 비교 연산자. tail이랑 node가 같으면 (즉, 삽입을 원하는 위치의 노드가 마지막 노드라면) append 오퍼레이터를 돌리는 거랑 똑같으니까 append 를 수행하고 종료
3. tail이랑 node가 다르면 (즉, 삽입을 원하는 위치의 노드가 마지막 노드가 아니라면) 해당 노드의 다음 노드로 추가하려는 값을 가지는 노드를 생성해서 지정해주고 종료

동작시켜보자

```swift
var list = LinkedList<String>()
list.append("동해물과")
//list.append("백두산이")
list.append("마르고닳도록")
list.append("하느님이")
list.append("보우하사")
//list.append("우리나라만세")
print(list) // 동해물과 -> 마르고닳도록 -> 하느님이 -> 보우하사  
let insertAfter = list.node(at: 0)!
list.insert("백두산이", after: insertAfter)
print(list) // 동해물과 -> 백두산이 -> 마르고닳도록 -> 하느님이 -> 보우하사
let tailNode = list.node(at: 4)!
list.insert("우리나라만세", after: tailNode) // equal append
print(list) //동해물과 -> 백두산이 -> 마르고닳도록 -> 하느님이 -> 보우하사 -> 우리나라만세
```

---

### push, append, insert, node(at:) Performance

![Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image%202.png](Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image%202.png)

---

### pop

첫번째 값 제거 

```jsx
extension LinkedList {
  @discardableResult
  public mutating func pop() -> Value? {
    defer {
      head = head?.next
      if isEmpty {
        tail = nil
      }
    }
    return head?.value
  }
}

var list = LinkedList<Int>()
list.push(3)
list.push(2)
list.push(1)
list.pop()
print(list) // 2 -> 3
```

- 제거된 첫번째 값을 반환한다. 옵셔널인 이유는 list가 empty일 때 nil을 리턴하기 때문이다.
- head를 이전 head에 대치하여 첫 노드를 제거하는 방식
- ARC는 메서드가 종료되었을때 old node를 메모리에서 해제한다 = 레퍼런트 카운트가 0이 된다
- list가 empty면 tail을 제거해준다.

---

### remove last

마지막 값 제거

```jsx
extension LinkedList {
  @discardableResult
  public mutating func removeLast() -> Value? {
    //1
    guard let head = head else { return nil }
    //2
    guard head.next != nil else { return pop() }
    //3
    var prev = head
    var current = head
    
    while let next = current.next {
      prev = current
      current = next
    }
    //4
    prev.next = nil
    tail = prev
    return current.value
  }
}
```

1. head가 없으면 empty list 이므로 nil을 반환하면서 메서드를 종료, head가 있으면 언래핑 참조 상수를 생성
2. head.next가 nil이면 `pop` 메서드를 이용해서 첫번째 value를 제거하여 반환하고 종료.
3. next value가 없을때까지 순회하여 prev가 마지막 value 한칸 앞을 참조, current가 마지막 value를 참조
4. prev의 next value를 제거하고, prev를 tail로 대치한다. 그리고 제거하는 value인 current value를 반환하면서 메서드 종료

```jsx
var list = LinkedList<Int>()
list.push(3)
list.push(2)
list.push(1)
list.removeLast() // 3
print(list) // 1 -> 2
```

---

### remove(after:)

특정 위치의 값 제거

1. 삭제하기를 원하는 노드의 직전 노드를 찾는다
2. 해당 노드와 다음 노드의 연결을 제거한다

![Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image%203.png](Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image%203.png)

```jsx
extension LinkedList {
  @discardableResult
  public mutating func remove(after node: Node<Value>) -> Value? {
    defer {
      if node.next === tail { // 제거하려는 노드가 tail인 경우
        tail = node
      }
      node.next = node.next?.next
    }
    return node.next?.value
  }
}
```

제거하려는 노드가 tail 노드인 경우가 예외 케이스이다.

tail reference의 업데이트가 필요하기 때문이다.

```jsx
var list = LinkedList<Int>()
list.push(3)
list.push(2)
list.push(1)
let index = 1
let node = list.node(at: index - 1)!
let removedValue = list.remove(after: node)
print(list) // 1 -> 3
```

여기서 node(at:) 실행 이후에 remove(after:)는 O(1) 시간복잡도를 가진다

---

### pop, removeLast, remove(after:) performance

![Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image%204.png](Linked%20List%20(%E1%84%8C%E1%85%A1%E1%86%A8%E1%84%89%E1%85%A5%E1%86%BC%E1%84%8C%E1%85%AE%E1%86%BC)%20d63cb30a27cd453ca7ccf000e9b72242/image%204.png)

---

### Swift collection protocols

Swift standard library는 특정 타입을 정의하기 위한 프로토콜이 정의되어있다.

프로토콜은 채택되는 타입으로 하여금 어떤 특성과 성능을 보장하도록 한다.

4개의 프로토콜로 이루어진 Collection Protocol Set 이 있다.

1. `Sequence`

    sequence를 채택한 타입은 순차적 접근을 제공한다. 주의할 점은, 순차적 접근을 사용하였을 때 element가 파괴적으로 소모될 수 있다는 것이다. <순회하는 도중에 element의 immutable이 보장되지 않는다는 말인것 같은데?>

2. `Collection`

    Collection을 채택한 타입은 기본적으로 sequence가 보장하는 특성에 더하여 추가적인  특성을 보장한다.

    - 유한한 element
    - 비파괴적인 순차 접근
3. `BidrectionalCollection` <양방향 콜렉션>

    시퀀스를 양방향으로 순회할 수 있다.

    linked list는 단방향 흐름을 제공하기 때문에 linkedList에서는 채택하지 않는다

4. `RandomAccessCollection`

    BidrectionalCollection의 특성에 더하여 특정 index의 element에서 다른 index로 접근할 때 항상 동일한 시간이 걸리는 것이 보장되는 경우 RandomAccessCollection을 따른다고 한다.

    LinkedList에서는 가까운 노드일 수록 접근 시간이 짧아지므로 RandomAccessCollection을 채택한 타입이 아니다.

Linked list의 경우

- sequence - 노드의 체인이므로
- collection - 노드 체인은 유한한 시퀀스