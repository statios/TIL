# The View Controller Hierarchy

## The Root View Controller

RootViewController는 ViewController 계층 구조의 가장 바닥에 놓입니다.

모든 window는 RootViewController를 소유하여 그것의 content를 window에 채웁니다.

그렇기 때문에 RootViewcontroller에서 사용자가 볼 수 있는 initial content를 정의합니다.

window는 자기 스스로 눈에 보이는 content를 소유하지 않고, 

ViewController의 view의 content를 window에 나타내게 됩니다.

![The%20View%20Controller%20Hierarchy%20c0f0045e0e604c0da73771bc4a0d3040/image.png](The%20View%20Controller%20Hierarchy%20c0f0045e0e604c0da73771bc4a0d3040/image.png)

window는 rootViewController라는 프로퍼티를 통해서 RootViewController에 접근할 수 있습니다.

스토리보드를 사용하는 경우 launch time에 자동으로 window.rootViewController에 값을 set합니다.

window를 코드로 생성하는 경우에는 반드시 RootViewController set 해주어야 합니다.

## Container View Controllers

ContainerViewController는 하나 이상의 child ContentViewController를 조합하여 구성합니다.

UIKit에서 UINavigationController, UISplitViewController and UIPageViewController 등을 제공합니다.

- ContainerViewController의 view는 항상 주어진 공간을 꽉 채우게 됩니다.
- 보통 window의 RootViewcontroller로 지정되는 경우가 많습니다.
- 다른 Controller의 child로 지정될 수 있습니다.
- modally present될 수 있습니다.
- ContainerVC는 child views를 적절하게 위치 시켜야 합니다.

![The%20View%20Controller%20Hierarchy%20c0f0045e0e604c0da73771bc4a0d3040/image%201.png](The%20View%20Controller%20Hierarchy%20c0f0045e0e604c0da73771bc4a0d3040/image%201.png)

ContainerViewController는 children ViewControllers를 관리하기 때문에,

custom containers의 children을 어떻게 세팅하는지에 대한 규칙을 제공합니다.

## Presented View Controllers

ViewController를 present하였을 때 UIKit은 presentingViewController와 presentedViewController의 관계를 생성합니다.

이러한 관계는 ViewController 계층구조의의 일부를 구성하며 런타임에 다른 ViewController를 찾을 수 있게 합니다.

![The%20View%20Controller%20Hierarchy%20c0f0045e0e604c0da73771bc4a0d3040/image%202.png](The%20View%20Controller%20Hierarchy%20c0f0045e0e604c0da73771bc4a0d3040/image%202.png)

ContainerViewController가 관련된 경우에 

UIKit은 개발자가 작성해야하는 코드를 단순하게 하기 위해서 presentation chain을 수정할 수 있습니다.

presentation style에 따라 화면이 나타나는 방식이 다릅니다.

예를 들면 full-screen presentaion은 항상 전체 screen을 cover합니다.

어떤 ViewController를 present를하면 

UIKit은 적절한 VC를 찾아서 해당 VC에서 present합니다.

보통은 가장 가까운 ContainerViewController가 선택되며 

window.rootViewController가 선택되는 경우도 있습니다.

또한 UIKit에 직접 지정해줄 수도 있습니다.

보통 가까운 ContainerViewController가 선택되는 이유는,

full-screen present를 수행할때 새로운 Viewcontroller는 화면 전체를 덮게됩니다.

그러려면 전체 screen의 bounds를 알고 있는 ContainerViewController가 

present를 처리하는 편이 더 좋기 때문입니다.

![The%20View%20Controller%20Hierarchy%20c0f0045e0e604c0da73771bc4a0d3040/image%203.png](The%20View%20Controller%20Hierarchy%20c0f0045e0e604c0da73771bc4a0d3040/image%203.png)