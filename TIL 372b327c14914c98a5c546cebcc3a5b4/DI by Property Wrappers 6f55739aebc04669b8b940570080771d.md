# DI by Property Wrappers

[Swift DI using Property Wrappers](https://avdyushin.ru/posts/swift-property-wrappers/)

## Dependency Injection

---

DI는 객체의 생성과 사용을 분리하도록 돕는다.

의존성을 사용하여서 객체의 변경 업이 특정 수행을 대체할 수 있다. (ex. 단위테스트)

아래 예시는 Service-ViewModel 간 커플링이 발생한 경우이다.

```swift
class Service {
}

class ViewModel {
  let service: Service
  init() {
    //ViewModel은 Service가 어떻게 생성되는지 알고 있다
    self.service = Service()
  }
}
```

ViewModel이 Service를 직접 생성하지 않도록 하기 위해서 property 주입을 사용할 수 있다

```swift
class MockService: Service { }
class ViewModel {
  let service: Service
  init(service: Service) {
    //Service의 어떤 서브클래스라도 올 수 있다
    self.service = service
  }
}
```

프로토콜을 사용함으로써 구체적인 타입을 숨길 수 있으므로, ViewModel은  객체의 사용법만을 알고있어야 한다.(생성이 아닌)

우리의 목표는 아래처럼 property wrapper를 이용해서 DI를 구현하는 것이다.

```swift
protocol ServiceProtocol { }
class Service: ServiceProtocol { }
class MockService: ServiceProtocol { }
class ViewModel {
  @Injected var service: ServiceProtocol
  init() {
    // ViewModel can start using service
    service.start()
  }
}
```

이러한 목표 달성을 위해서 3가지 주요 컴포넌트가 필요하다

1. Dependency resolver
2. Dependency container
3. Custom property wrapper

## Dependency Resolver

---

Dependency Resolver는 간단한 factory다.

Dependency Container에 주입하기를 원하는 객체를 리턴하는 block을 제공한다.

```swift
struct Dependency {
  typealias ResolveBlock<T> = () -> T
  
  // resolve()이후에 할당되는 실제 값
  private(set) var value: Any!
  
  private let resolveBlock: ResolveBlock<Any>
  let name: String
  
  init<T>(_ block: @escaping ResolveBlock<T>) {
    resolveBlock = block // Save block for future
    name = String(describing: T.self)
  }
  
  mutating func resolve() {
    value = resolveBlock()
  }
}
```

실제 주입은 `resolve()` 호출 이후에 수행됨

```swift
var service = Dependency { Service() }
service.value // nil
service.resolve()
service.value // Service instance
```

## Dependency Container

Dependency Conainer는 추가된 dependency 객체들을 관리한다.

1. Register given `Dependency` in container;
2. Build resolved dependencies list;
3. Resolve single dependency of given type.

```swift
class Dependencies {
  
  static private(set) var shared = Dependencies() // 1
  
  fileprivate var dependencies = [Dependency]() // 2
  
  func register(_ dependency: Dependency) {
    // Avoid duplicates
    guard dependencies.firstIndex(where: { $0.name == dependency.name }) == nil else {
      debugPrint("\(String(describing: dependency.name)) alread registered, ignoring")
      return
    }
    dependencies.append(dependency)
  }
  
  func build() {
    // We assuming that at this point all needed dependencies are registered
    // 이 시점에서 필요한 모든 종속성이 등록되었다고 가정함
    for index in dependencies.startIndex..<dependencies.endIndex {
      dependencies[index].resolve()
    }
    Self.shared = self // 3
  }
  
  func resolve<T>() -> T {
    guard let dependency = dependencies.first(where: { $0.value is T })?.value as? T else {
      fatalError("Can't resolve \(T.self)")
    }
    return dependency
  }
  
}
```

1. container로 접근하는 main point
2. resolve와 access가 가능한 dependency 목록
3. resolve가 완료되면 shared value를 업데이트 해줘야함

Now we can setup simple dependency container with injected service:

```swift
protocol LocationService { /* start() */ }
protocol JourneyService { /* start() */ }
class MockLocation: LocationService { /* start() */ }
class MockJourney: JourneyService { /* start() */ }

let location = Dependency { MockLocation() } // Future injection of LocationService
let journey = Dependency { MockJourney() } // Future injection of JourneyService
let dependencies = Dependencies()
dependencies.register(location)
dependencies.register(journey)
```

여기서는 resolve될 블록들만 저장하였기 때문에, build()로 셋업을 완료하면된다.

```swift
dependencies.build()
```

그리고 `viewModel` 안에서 사용한 코드이다.

```swift
class ViewModel {
  let service: LocationService = Dependencies.shared.resolve()
  init() {
    service.start() //Service is MockLocaion instance
  }
}
```

이제 `Dependencies.shared` 말고 `@propertyWrapper` 를 써보자

## Property Wrapper

Property wrapper는 멤버변수로 `wrappedValue` 를 가진다.

우리는 이제 Dependency container를 property wrapper로 감쌀거다.

```swift
@propertyWrapper
struct Injected<Dependency> {
  
  var dependency: Dependency! // resolved dependency
  
  var wrappedValue: Dependency {
    mutating get {
      if dependency == nil {
        let copy: Dependency = Dependencies.shared.resolve()
        self.dependency = copy
      }
      return dependency
    } mutating set {
      dependency = newValue
    }
  }
  
}
```

usage

```swift
@injected var service: LocationService
```

## Using swift DSL for container

Adding @_functionBuilder struct and convenience initializers into Dependencies class will make it more Swifty:

```swift
class Dependencies {
  
  @_functionBuilder struct DependencyBuilder {
    static func buildBlock(_ dependency: Dependency) -> Dependency { dependency }
    static func buildBlock(_ dependencies: Dependency...) -> [Dependency] { dependencies }
  }
  
  convenience init(@DependencyBuilder _ dependencies: () -> [Dependency]) {
    self.init()
    dependencies().forEach { register($0) }
  }
  
  convenience init(@DependencyBuilder _ dependency: () -> Dependency) {
    self.init()
    register(dependency())
  }

  /* Previous code */

}
```

Usage:

```swift
let dependencies = Dependencies {
  Dependency { LocationImpl() }
  Dependency { JourneyImpl() }
  // ...
}
dependencies.build()
```

## Iterate over injected dependencies

If we need to manipulate on set of injected dependencies we can make dependency container conform to Sequence protocol:

```swift
extension Dependencies: Sequence {
  func makeIterator() -> AnyIterator<Any> {
    var iter = dependencies.makeIterator()
    return AnyIterator { iter.next()?.value }
  }
}
```

Now it’s easy to find all dependencies of given protocol and do what we want:

```swift
protocol Resettable { func reset() }
Dependencies.shared
  .compactMap { $0 as? Resettable }
  .forEach { $0.reset() }
```