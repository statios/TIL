# basic  swift data structure

### 스위프트 구조체의 주요 기능

- 자동으로 생성되는 멤버 초기화 함수 제공
- 커스텀 초기화 함수 정의 가능
- 메소드 정의 가능
- 프로토콜 구현 가능

### 구조체 사용 가이드

[Structures and Classes - The Swift Programming Language (Swift 5.3)](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html)

- 특정 타입 생성의 가장 중요한 목적이 간단한 몇 개의 값을 캡슐화하려는 것인 경우
- 캡슐화한 값을 구조체의 인스턴스에 전달하거나 할당할 때 참조가 아닌 복사를 할 경우
- 구조체에 의해 저장되는 프로퍼티를 참조가 아닌 복사를 위한 밸류 타입인 경우
- 기존의 타입에서 가져온 프로퍼티나 각종 기능을 상속할 필요가 없는 경우

위 조건 중 하나라도 해당된다면 클래스보다는 구조체를 사용하는 것이 좋다.

### Array

[배열](basic%20swift%20data%20structure%2059dc93768e1e45d0939a82cd1a942153/%E1%84%87%E1%85%A2%E1%84%8B%E1%85%A7%E1%86%AF%20f8b96847bc49406db4471770be2a690a.md)

### Dictionary

[딕셔너리](basic%20swift%20data%20structure%2059dc93768e1e45d0939a82cd1a942153/%E1%84%83%E1%85%B5%E1%86%A8%E1%84%89%E1%85%A7%E1%84%82%E1%85%A5%E1%84%85%E1%85%B5%20682e3e7cf6d04d2fb3a53d97faf8cd8a.md)

### Objective-C 메시지

- 스위프트의 메서드와 같다
- 옵씨 메시지의 구성 요소
    - Receiver → 메시지의 반환값을 할당받는 객체
    - Selector → 메시지의 이름
    - Parameter → 스위프트 메소드의 파라미터와 같다

### objc 동적 바인딩 - dynamic binding

objc 메시지로 모델을 전달할 때는 컴파일 시점 바인딩x → 동적 바인딩o

따라서 런타임에 특정 메시지를 구현하여 실행하는 것이 가능하다

런타임에 메시지를 구현하여 실행하더라도 해당 객체가 즉각 반응할 수 없는 경우에는 해당 객체를 상속받은 애들을 찾을 때까지 기다렸다가 메시지를 실행함

결국 해당 객체를 찾을 수 없을 때는 nil을 반환한다 (컴파일러 설정에서 변경 가능)

### initializer objc → swift

```objectivec
[[NSString alloc] initWithFormat:@"%d-%d". 32259, 1234];
```

```swift
NSString(format: "%d-%d", 32259, 1234)
//convenience init(format: NSString, _ args: CVarArgType...)
```

옵씨 프레임워크를 스위프트로 임포트하면 이니셜라이저가 다음 규칙에의해 변환됨

- 셀렉터 이름에서 with가 제거됨
- 셀렉터 이름에서 format이 매개변수명으로 이동
- convenience init
- 매개변수명 지정됨 (args..)

### class swift → objc

- NSObject를 상속하거나 다른 objc 클래스를 상속 받은 클래스여야함
- NSObject를 상속받지 않았어도 `@objc` 속성으로 해당 메서드에 접근 가능하다
- `@objc` 속성은 swift 메서드, 프로퍼티, 초기화객체, 서브스크립트, 프로토콜, 클래스, 열거형 등에 모두 적용 가능
- `@objc(SomeClassName)` → objc에서 SomeClassName으로 바로 접근 가능

### Michael Feathers 의 SOLID 원칙

구조체와 클래스 개발의 다섯가지 원칙

1. 단일 책임 원칙 → 하나의 클래스는 오직 하나의 책임만 가진다
2. 개방 폐쇄 원칙 → 확장에 개방적이며 수정에 폐쇄적이다
3. 리스코프 대체 원칙 → 특정 클래스에서 분화돼 나온 클래스는 원본 클래스로 대체 가능해야 한다
4. 인터페이스 세분화 원칙 → 개별적인 목적에 대응할 수 있는 여러 개의 인터페이스가 일반적인 목적에 대응할 수 있는 하나의 인터페이스보다 낫다
5. 의존성 역전 원칙 → 구체화가 아닌 추상화를 중시한다

### NSArray → Array 옵씨 스위프트 브릿징

- as 키워드를 사용하여 타입캐스팅 해주면 된다
- 다만 NSArray는 element로 단일한 타입이 보장되지 않으므로
- 옵셔널 타입 캐스팅하거나 [AnyObject] 캐스팅하거나 해야한다

### 프로토콜

- 프로토콜은 하나 이상의 프로토콜을 상속할 수 있다
- 프로토콜 컴포지션 → 여러 개의 프로토콜을 묶어서 하나의 프로토콜 처럼 사용 (& 기호 사용)
- 프로토콜 자체를 하나의 타입으로 사용할 수 있다

### ExpressibleByArrayLiteral (protocol)

Array 리터럴 문법을 제공할 수 있는 프로토콜

```swift
struct Person {
  var name: String
  var age: Int
}

struct People: ExpressibleByArrayLiteral {
  var items: [Person]
  init(arrayLiteral elements: Person...) {
    self.items = elements
  }
}

let ourMates = People(arrayLiteral: Person(name: "A", age: 1),
							                      Person(name: "B", age: 2),
							                      Person(name: "C", age: 3))
```