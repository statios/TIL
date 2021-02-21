# The Role of View Controllers

ViewController는 앱 내부 구조의 근간이 됩니다.

모든 앱은 적어도 하나의 ViewController를 가지며 대부분은 다양한 ViewController를 포함합니다.

각각의 ViewController는 아래의 것들을 관리합니다.

- UI
- 유저 인터랙션에 따른 데이터 흐름
- 화면이동(transition)

앱에서 중요한 역할을 하는만큼 거의 대부분의 것들의 중심이됩니다.

UIViewController 클래스에는 

UI, event handling, transition을 위한 다양한 메서드와 프로퍼티가 정의되어 있습니다.

또한 UIViewController를 subclass하여 앱 동작을 위해 필요한 커스텀 코드를 추가할 수 있습니다.

크게 두가지 타입의 ViewController가 있습니다.

- Content를 나타내는 ViewController
- Content ViewController를 포함하는 Container ViewController

    Ex. UINavigationController, UITabBarController

대부분의 앱은 두 형태의 ViewContoroller 조합하여 구현합니다.

## View Managerment

ViewController의 가장 큰 역할은 view 계층 구조를 관리하는 것입니다.

모든 ViewController 하나의 root view를 가집니다.

root view는 ViewController의 모든 content를 포함하고 있습니다.

![The%20Role%20of%20View%20Controllers%20920c6b3b6ed84a269f1ab0edcc99bd2f/image.png](The%20Role%20of%20View%20Controllers%20920c6b3b6ed84a269f1ab0edcc99bd2f/image.png)

화살표 방향은 강한 참조 방향을 나타냅니다. 모든 View는 subview에 대해서 강한 참조합니다.

ContentViewController는 root view subviews를 포함한 모든 뷰를 관리합니다.

ContainerViewController는 자신의 views와 ChildViewControllers의 root view만을 관리합니다.

ContainerViewController는 children의 content에 대해서는 관리하지 않습니다.

단지 container의 design에 따른 child root view의 사이징, 위치만 관리할 뿐입니다.

![The%20Role%20of%20View%20Controllers%20920c6b3b6ed84a269f1ab0edcc99bd2f/image%201.png](The%20Role%20of%20View%20Controllers%20920c6b3b6ed84a269f1ab0edcc99bd2f/image%201.png)

## Data Marshaling

ViewController는 View-Data의 중간에서 중재자 역할을 합니다.

UIViewController의 프로퍼티와 메서드를 통해서 화면에 보이는 것들을 관리할 수 있습니다.

UIViewController를 subclass하여 data를 관리하기위한 변수나 메서드를 작성하여 사용합니다.

![The%20Role%20of%20View%20Controllers%20920c6b3b6ed84a269f1ab0edcc99bd2f/image%202.png](The%20Role%20of%20View%20Controllers%20920c6b3b6ed84a269f1ab0edcc99bd2f/image%202.png)

ViewController-Data Object 내에서 책임의 분리를 clean하게 유지해야합니다.

보통 데이터 구조의 무결성을 보장하기 위한 로직은 Data Object 자체에 정의됩니다.

ViewController는 View에서 user input을 전달받아서 

DataObject에 필요한 format으로 user input을 변형하여 요청할 수는 있지만,

DataObject로부터 전달받은 actual data를 조작하는 것은 최소화해야합니다.

UIDocument 객체는 ViewController로부터 data를 분리하여 관리하는 방법 중에 하나입니다.

UIDocument 객체는 영구 저장소의 데이터를 read and write하는 동작을 제공합니다.

subclass에서 해당 데이터를 가져오는 데 필요한 로직이나 메서드를 정의하여 

ViewController 또는 앱의 다른 부분에 전달합니다.

ViewController는 view 업데이트를 용이하게 하기 위해서 수신되는 데이터의 복사본을 저장하며,

document에서는 true data를 유지합니다.

## User Interactions

ViewController는 responder 객체이며 responder chain으로 내려오는 이벤트를 처리할 수 있습니다.

하지만 ViewController에 직접적으로 수신되는 이벤트를 처리하는 경우는 거의 없습니다.

일반적으로는 Views에서 발생하는이벤트를

관련 delegate 또는 target object(주로 ViewController)의 메서드로 결과를 전달합니다.

그래서 보통 ViewController의 event는 delegate나 action methods를 사용하여 처리됩니다.

## Resource Management

ViewController는 Views와 생성한 object에 대해서 모든 책임을 집니다.

UIViewController는 views 관리의 대부분을 자동으로 처리합니다.

예를 들면 UIKit은 view-related resources가 더이상 필요하지 않을 때 자동으로 releases 합니다.

UIViewController subclasses에서 명시적으로 생성한 object가 있다면 직접 관리해줘야 합니다.

사용 가능한 메모리가 부족할 때 UIKit은 앱에 더이상 필요없는 리소스의 해제를 요청합니다.

didReceiveMemoryWarning 메서드에서 

더이상 필요없거나 이후에 recreate하는 것이 쉬운 object를 참조 해제 하도록 지정해줄 수 있습니다.

예를들면 캐시 데이터를 제거해줄 수도 있어요.

low-memory condition이 발생하면 가능한 많은 메모리를 해제하는 것이 중요합니다.

너무 많은 메모리를 잡아먹는 앱은 시스템에서 메모리 확보를 위해서 앱을 강제 종료 시킬 수도 있거든요.

## Adaptivity — 적응성

ViewController에서 environment(다양한 기기환경을 말하는듯)에 맞는 화면을 나타내고 

필요하다면 조정해야합니다.

모든 iOS 앱은 사이즈가 다른 다양한 기기에서 실행될 수 있어야 합니다.

이때 device마다 각각 다른 ViewControllers와 view 하이라키를 제공하는것 보다는,

같은 ViewController를 사용하면서 사이즈에 따라 적응할 수 있도록 해야합니다.

ViewController는 coarse-grained changes와 fine-grained changes를 핸들링 해주어야 합니다.

Coarse-grained changes는 ViewController 디스플레이 크기와 같은 전체적인 특성(traits)이 변할때 발생합니다.

가장 중요한 특성(traits)은 ViewController의 가로와 세로 사이즈 classes입니다.

그 classes는 주어진 방향에서 ViewController가 공간을 얼만큼 차지하는지를 나타냅니다.

사이즈 클래스를 사용해서 view의 레이아웃을 변경해줄 수 있습니다.

horizontal size class가 regular일 때 ViewController는 추가적인 가로 공간을 활용하여 콘텐츠를 정렬할 수 있습니다.

또는 horizontal size class가 compact일 때 ViewController는 콘텐츠를 세로로 정렬할 수 있습니다.

![The%20Role%20of%20View%20Controllers%20920c6b3b6ed84a269f1ab0edcc99bd2f/image%203.png](The%20Role%20of%20View%20Controllers%20920c6b3b6ed84a269f1ab0edcc99bd2f/image%203.png)

지정된 size class 내에서 more fine-grained size 변화는 얼마든지 발생할 수가 있어요.

사용자가 화면 방향을 portrait에서 landscape로 바꾸는 경우에,

size class는 변경되지 않지만 screen dimensions는 일반적으로 변경됩니다.

Auto Layout을 사용한다면 UIKit은 새로운 dimensions에 맞춰서 크기와 위치를 자동적으로 조절합니다.

물론 필요하다면 ViewController에서 추가적으로 조절하는 동작을 추가해 줄 수도 있습니다.