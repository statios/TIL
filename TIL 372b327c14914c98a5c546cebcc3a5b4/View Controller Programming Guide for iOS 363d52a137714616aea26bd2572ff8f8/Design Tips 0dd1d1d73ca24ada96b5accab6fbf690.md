# Design Tips

Custom ViewController를 구현할 때 아래의 가이드를 따라서 작성하여,

시스템에서 예상하는 자연스러운 동작을 방해할만한 작업을 수행하지 않도록 합시다.

## Use System-Supplied View Controllers Whenever Possible

iOS 프레임워크에서 제공하는 ViewController를 최대한 사용하여 

1. 개발 시간도 절약하구요
2. 사용자에게 일관적인 경험을 제공

하시기 바랍니다.

특정 목적을 처리할 수 있도록 디자인된 여러 System ViewController가 있어요.

그러니까 Custom ViewController를 구현하기전에 이미 시스템에서 제공하는게 있는지 찾아보는게 좋습니다.

![Design%20Tips%200dd1d1d73ca24ada96b5accab6fbf690/Untitled.png](Design%20Tips%200dd1d1d73ca24ada96b5accab6fbf690/Untitled.png)

생각보다 많습니다...

다만, 시스템에서 제공하는 ViewController를 사용하는 경우에

view hierarchy를 임의로 수정하지 마세요. 

예기치 못한 문제가 발생할 수 있습니다.

필요한 경우에는 ViewController에서 publicly 제공하는 메소드나 프로퍼티를 사용해서 수정하시기 바랍니다.

## Make Each View Controlleran Island

ViewController는 다른 ViewController의 뷰 계층구조나 내부 동작에 대해서 몰라야 합니다.

두 ViewController가 데이터를 주고 받아야하는 경우에, 엄격하게 정의된 public interface를 사용해야 합니다.

델리게이트 패턴은 ViewController 간의 커뮤니케이션을 관리하는데 유용합니다.

이때 델리게이트 프로토콜을 채택한 객체라면 그 객체의 타입은 중요하지 않습니다.

중요한거는 그 객체가 프로토콜에 정의된 메서드를 구현한다는 것입니다.

## Use the Root View Only as a Container for Other Views

ViewController의 root view는 나머지 content의 container로만 사용하세요.

그렇게 하면 모든 view의 공통 super view가 되므로 레이아웃 작업이 간단해 집니다.

오토레이아웃을 지정하기 위해서 공통의 super view가 필요하기 때문입니다.

## Know Where Your Data Lives

MVC에서 ViewController의 역할은 Model-View의 중간에서 데이터를 쉽게 이동시키는 것입니다.

ViewController는 어떤 데이터를 임시적으로 저장하고 유효성 검사를 하는 등의 작업을 할 순 있지만,

주된 역할은 view가 정확한 정보를 나타내도록 보장하는 것입니다.

Data object는 실제 데이터(actual data)를 관리하고 데이터의 총체적인 무결성을 보장하는 역할을 합니다.

Data-interface 분리의 사례는 UIDocument-UIViewController의 관계 입니다.

UIDocument object는 데이터의 load and save를 담당하고,

UIViewController object는 화면에 나타내는 부분을 담당합니다.

두 객체간의 관계를 생성했다면, ViewController는 효율성을 위해서 

UIDocument의 데이터를 임시적으로 저장(캐시)하는 것만 할 수 있다는 것입니다.

실제 데이터는 여전히 document object에 두어야 합니다.

## Adapt to Changes

Apps can run on a variety of iOS devices, and view controllers are designed to adapt to different-sized screens on those devices. Rather than use separate view controllers to manage content on different screens, use the built-in adaptivity support to respond to size and size class changes in your view controllers. The notifications sent by UIKit give you the opportunity to make both large-scale and small-scale changes to your user interface without having to change the rest of your view controller code.