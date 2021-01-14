# SwiftUI App Architecture

SwiftUI를 실제 프로덕트 레벨에서 사용하기 위해서 다음 사항을 고려한 아키텍처가 디자인되어야 한다.

- 다양한 작업자가 이해할 수 있도록 관심사가 분리되어야 함
- Mock 데이터를 통하여 UI를 프리뷰 하고 효율적으로 개발되어야 함
- 유닛 테스트가 가능해야 함

View와 ObservableObject간 바인딩 뿐만아니라 앱 전체에서 이벤트 전달 매커니즘으로 Combine을 활용한다.

기존의 MVVM 아키텍처 패턴을 차용하여 SwiftUI와 Combine을 통하여 구현한다.

## Our architecture for SwiftUI/Combine apps

![SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image.png](SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image.png)

Overview of architecture

### **View**

- 모든 SwiftUI `View` 코드를 포함한다
- `View` 구조체는 가능한 작게 유지한다
- 최대한 reusable small View로써 관리한다

꽤 복잡한 real world app에서 state를 어디에 둘지 결정하기 힘든 경우가 많은데 이거에 대한 명확한 가이드가 없다. 따라서 아래의 가이드를 제안한다.

- `@state private var` — state가 view 내부에서만 사용되는경우. business logic과 상관이 없고 단순히 UI내에서만 필요한 상태일 때 사용
- `@Binding var` —  sub-view가 parenet-view의 state를 referencing 하는 경우에사용. sub-view는 parent view의 state를 소유하지는 않지만 parent view의 해당 state에 따라  UI를 update.
- `@ObservedObject var` — UI 뿐만아니라 앱의 로직적인 부분에 관련된 상태값. 일반적으로 View에서 스스로 소유하는 것이 아니라 부모 View로부터 전달받게됨. 고로, parent-view가 재생성될때마다 ObservableObject또한 재생성된다. Example: state of a specific screen in the app.
- `@StateObject private var` — StateObject는 iOS 14+ 에서 사용 가능하다. ObservedObject랑 비슷한데, UI 뿐만아니라 View와 subviews에 대한 상태를 포함한다. 하지만 view가 표시될 때마다 재생성되지는 않는다. 따라서 ObservedObject와 StateObject중 하나를 선택할 때는 매번 viewModel을 생성할지 말지를 판단하면 쉽다. Example: state of a specific screen in the app.
- `@EnvironmentObject var` — View 계층에 주입된 ObservableObject로 모든 계층에서 쉽게 접근할 수 있다. (내부적으로 싱글톤으로 동작). UI 뿐만 아니라 앱 비즈니스 로직 상의 상태도 포함한다. 보통 앱 전체의 View에 대해서 SceneDelegate에서 ViewModel을 주입한다. When choosing between @EnvironmentObject and @ObservedObject/@StateObject, there is a tradeoff between having states easily available but widely exposed or having states less conveniently available (pass it through initializer in the hierarchy) but scoped to where it must be used. NavigationLink 또는 .sheet()를 사용할때는 EnvironmentObject를 사용하여 다시 전달해야 한다.

SBB Inclusive App 에서는 메인 ViewModel에 쉽게 접근하기 위해서 EnvironmentObject를 많이 사용하였다.  또한 ObservedObject는 많이 사용하지는 않았고 주로 온보딩 같은 특정 기능에만 사용하였다. StateObject는 iOS 14+에서만 사용 가능해서 사용하지 않았다. State와 Binding은 주로 특정 UI Component에서 View 재사용을 위해서 사용되었다.

### **ViewModel**

ViewModel의 주요 목적은 Model 레이어에서 trigger된 event에 반응하고 그러한 이벤트를 Published var로 변환하는 것이다. 그리고 그 Published var를 view에서 사용하게 된다. ViewModel은 주로 모델 레이어에 위치한 Publisher들을 subscribe 한다. Publisher의 이벤트들은 메인 스레드에서 전송되며 Published var에 할당된다. 때로는 값을 변환하거나 .sink()를 사용하여 여러 @Published 변수에 할당하는 등 보다 복잡한 작업이 필요하다.

ViewModel은 Published vars를 소유하는 ObservableObject 클래스로 정의되며 View와 Model 레이어의 에서 사용된다. 또한 ViewModel은 View의 trigger된 동작에 의한 기능들을 포함한다. 

이니셜라이저에서 디펜던시를 위한 디폴트 implementation을 제공한다. 해당 부분은 유닛테스트에서 fake implementation으로 오버라이드 하여 사용된다.

```swift
class ViewModel: ViewModelProtocol {
	@Published var value: Int = 0
	
	init(model: ModelProtocol = Model()) {
		//...
	}

	func action() {
		//...
	}
}
```

ViewModel implementation에서는 바로 ObservableObject 프로토콜을 채택하지 않고, ViewModelType 프로토콜에서 상속받는다.

```swift
protocol ViewModelProtocol: ObservableObject {
	var value: Int { get set }

	func action()
}
```

이러한 프로토콜을 정의하는 목적은 FakeViewModel을 implement 할 수 있도록 하기 위해서다. 테스트를 위해서 꼭 필요하다.

```swift
class FakeViewModel: ViewModelProtocol {
	@Published var value: Int

	init(value: Int) {
		self.value = value
	}

	func action() {
		//...
	}
}
```

Preview와 test를 위해서 우리는 View 에서는 implementation이 아니라 protocol을 참조해야한다. 하지만 뷰에서 아래처럼 바로 뷰모델 프로토콜을 참조하면 에러가 발생한다.

```swift
struct ContentView: View {
	@EnvironmentObject var viewModel: ViewModelProtocol //compile error
}
```

We end up with this error: “Protocol ‘MyViewModelProtocol’ can only be used as a generic constraint because it has Self or associated type requirements”. We just have to use generic in order to solve this:

```swift
struct ContentView<M: ViewModelProtocol>: View {
	@EnvironmentObject var viewModel: M
}
```

viewModel → View 방향으로 navigation event가 전달되는 경우가 있다. 많은 디자인 패턴에서 이러한 navigation event를 처리하는 객체가 존재한다. 우리의 SwiftUI 아키텍처에서는 네비게이션 이벤트를 단지 앱의 state중의 하나로 관리된다. 

따라서 ViewModel에서 앱이 의존하는 navigation logic 상태를 포함한다. 그렇기 때문에 navigation 은 유닛 테스트가 가능한 대상이 된다.

### Model

앱 비즈니스 로직을 포함하는 다양한 컴포넌트로 구성되어 있다. Those components might also be responsible of providing the interface to external components (e.g. Networking, CoreLocation) and can also depend on each other. 가능한 컴바인을 적극 사용한다. 모델은 viewModel, View에 다음과 같은 것들을 제공할 수 있다.

- Publisher — which will stream events up the layers.
- Func — to triggers event down the layers.
- Publisher or Subject — to stream events down the layers.

```swift
class Model: ModelProtocol {
	var value: AnyPublisher<String, Never>

	init(service: ServiceProtocol = Service()) {
		//...
	}

	func action() {
		//...
	}
}
```

Model은 유닛테스트가 가능하도록 프로토콜을 채택하여 구현된다. 따라서 fake implementation 또한 해당 프로토콜을 채택하게 된다. 프로토콜에 Just, Future, CurrentValueSubject 같은 적절한 타입의 Publisher를 노출하면 좋겠지만 AnyPublsher로 정의한다. 따라서 Fake나 Concrete에서 각각 다른 타입의 Publisher를 사용할 수 있다.

```swift
protocol ModelProtocol {
	var value: AnyPublisher<String, Never> { get }

	func action()
}
```

### Data

Publisher를 통과하는 데이터 플로우는 immutable struct이다. 이상적으로 해당 Immutable struct는 Model로부터 View 또는 View를 통하여 ViewModel로 흘러야한다. 레이어에 필요한 것을 더 잘 반영하는 구조를 가지기 위해 그것들을 변환하는 것도 이치에 맞을 수 있다. 예를 들면 네트워킹 Model로부터 받은 payload는 ViewModel에서 사용되기 전에 비즈니스 로직에 맞게 매핑된 의미있는 struct로 변환 될 수 있다. 

이러한 ummutable Data struct를 persisting 하거나 전송하려면 codable 프로토콜을 채택하는 것이 타당하다.It is also a good practice to adopt Equatable and Identifiable protocols in a meaningful way for our business logic.

### Detailed architecture overview

- View는 하나 또는 여러 ViewModel에 의존한다.
- 각각의 viewModel은 하나 이상의 Model에 의존할 수 있다.
- 모든 레이어들은 immutable struct인 Data를 서로 교환한다.
- 모든 레이어는 그들 자신의 프로토콜을 채택한다.
- Fakes는 SwiftUI preview, UI Test, Unit test에 사용된다.

    ![SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image%201.png](SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image%201.png)

## Why does this design pattern fit our needs?

### 관심사의 분리

- View는 UI가 어떻게 표시될지에 대해서만 책임진다
- ViewModel은 View에 content를 제공하고 UI이벤트를 처리한다
- Model은 앱 비즈니스 로직과 외부 컴포넌트 추상 레이어를 포함한다

각각의 레이어는 개별적으로 테스트가 가능하다. 

![SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image%202.png](SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image%202.png)

### Unit Testing

ViewModel와 Model 레이어는 모두 유닛 테스트된다. 각각의 레이어는 테스트 시나리오에 맞는 값을 가지는 fake doubles를 가진다. 이것이 모든 레이어에 프로토콜이 선언되는 이유이다. normal class는 app  bundle내에, fake class는 test bundle에 위치한다.

![SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image%203.png](SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image%203.png)

```swift
class ViewModelTests: XCTestCase {
    
    private var viewModel: ViewModel!
    private var fakeModel: FakeModel!
    
    override func setUp() {
        fakeModel = FakeModel(isCounterStarted: false)
        viewModel = ViewModel(model: fakeModel)
    }
    
    func testModelUpdatesValue() {
        let expectation = self.expectation(description: "wait for value update")
        
        var i = 0
        let sub = viewModel.$value.sink { value in
            i += 1
            switch i {
            case 1:
                XCTAssertEqual(value, 0)
                self.fakeModel.valueSubject.send(5)
            case 2:
                XCTAssertEqual(value, 5)
                expectation.fulfill()
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5.0) { _ in
            sub.cancel()
        }
    }
}
```

### SwiftUI Previews with fake ViewModels

View의 content는 viewModel에 의존한다. preview가 가능하기 위해서 View는 모든 가능한 state를 제공하는 ViewModel인 FakeViewModel이 필요하다.

![SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image%204.png](SwiftUI%20App%20Architecture%205d2444a69ffa4b0fa2a4fb4660739e05/image%204.png)

We start by creating a ViewModelProtocol and then implement the FakeViewModel based on that protocol. Inside the view, you then use generics, to accept either the real or the fake implementation :

```swift
struct ContentView<Model: ViewModelProtocol>: View {
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        ...
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView<FakeViewModel>().environmentObject(FakeViewModel(value: 123))
                .previewDisplayName("123")
            ContentView<FakeViewModel>().environmentObject(FakeViewModel(value: 456))
                .previewDisplayName("456")
        }
    }
}
```

### UITesting

Our approach for UITesting is very similar to creating different previews. We also want to use our FakeViewModel with different content for our different UITest scenarios. When setting up UITests we set the launchEnvironment value for the key UI_TEST_SCENARIO.

```swift
class ContentViewUITests: XCTestCase {
    func testScenarioOne() throws {
        let app = XCUIApplication()
        app.launchEnvironment.updateValue("scenario1", forKey: "UI_TEST_SCENARIO")
        app.launch()
        
        XCTAssertEqual(...)
    }
}
```

We then check for this key in SceneDelegate (using precompiler flags) and inject the according FakeViewModel instead of the real ViewModel if the key is set.

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {        
        #if UITESTS
        let contentView: AnyView
        let scenarioName = ProcessInfo.processInfo.environment["UI_TEST_SCENARIO"]
        switch scenarioName {
        case "scenario1":
            contentView = AnyView(ContentView<FakeViewModel>().environmentObject(FakeViewModel(value: 123, isCounterStarted: true)))
        default:
            return
        }
        #else
        let contentView = ContentView<ViewModel>().environmentObject(ViewModel())
        #endif
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
```

## Conclusion

As you have seen, the design pattern we have presented here brings many benefits with it. It might be overkill for small apps… but we never know when an App will grow!

As soon as you work on a larger project, Unit Testing, UI Testing, previewing different view states and a clear separation of concerns become crucial for the success of the project and its maintenance on a long term. With this design pattern, we have an architecture which has proven to fit our needs.

We are still eagerly waiting for news or updates of SwiftUI and Combine. We were hoping for a larger adoption of Combine in other Apple frameworks with iOS 14. Unfortunately, this was not the case. Let’s wait and see what iOS 15 will have in petto for Combine. For SwiftUI, iOS 14 brought a few updates but it is still missing some important features.

## References

[SwiftUI App Architecture](https://medium.com/swlh/swiftui-app-architecture-124b0199d52c)