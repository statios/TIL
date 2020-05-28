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

    ![Linked%20List%20d63cb30a27cd453ca7ccf000e9b72242/image.png](Linked%20List%20d63cb30a27cd453ca7ccf000e9b72242/image.png)

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

![Linked%20List%20d63cb30a27cd453ca7ccf000e9b72242/image%201.png](Linked%20List%20d63cb30a27cd453ca7ccf000e9b72242/image%201.png)

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