# Implementing a Container View Controller

## Implementing a Custom Container View Controller

먼저 parent-child view controller 관계를 지정해야 합니다.

그렇게 하면 parent가 children view controller의 view의 사이즈와 위치를 관리하게 됩니다.

parent-child 관계는 스토리보드나 코드베이스로 지정할 수 있는데, 코드로 하는 경우에는

custom container view controller를 setup하는 부분에서 명시적으로

child view controllers를 add 또는 remove 해주어야 합니다.

### Adding a Child View Controller to Your Content

1. container view controller의 addChildViewController 메서드를 호출합니다.

    앞으로 container view controller가 child view controller의 views를 관리하겠다고 UIKit에 알림

2. container's view 계층에 child's root view를 추가합니다.
3. child's root view의 위치와 사이즈를 관리하기 위한 제약 조건을 추가합니다.
4. child view controller의 didMoveToParentViewController를 호출합니다.

```swift
import UIKit

class CustomContainerViewController: UIViewController {
  func displayContentViewControllers(contents: [UIViewController]) {
    let height = UIScreen.main.bounds.height / CGFloat(contents.count)
    contents.enumerated().forEach {
      //1.
      addChild($0.element)
      
      //2.
      view.addSubview($0.element.view)
      
      //3.
      $0.element.view.translatesAutoresizingMaskIntoConstraints = false
      $0.element.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      $0.element.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      $0.element.view.topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: height * CGFloat($0.offset)
      ).isActive = true
      $0.element.view.heightAnchor.constraint(equalToConstant: height).isActive = true
      
      //4.
      $0.element.didMove(toParent: self)
    }
  }
}
```

## Removing a Child View Controller

1. child view controller의 willMoveToParentViewController 메서드를 호출합니다. (with value nil)
2. child's root view에 걸려있던 제약 조건을 제거합니다
3. child's root view를 container's root view에서 제거합니다.
4. child의 removeFromParentViewController를 호출하여 parent-child 관계를 종료합니다.

```swift
func removeContentViewController(content: UIViewController) {
    //1.
    content.willMove(toParent: nil)
    
    //2.
    content.view.removeConstraints(content.view.constraints)
    
    //3.
    content.view.removeFromSuperview()
    
    //4.
    content.removeFromParent()
  }
```

### Transitioning Between Child View Controllers

어떤 child에서 다른 child로 애니메이션과 함께 전환하려고 할때,

트랜지션 애니메이션 과정에서 child의 제거와 추가를 해줍니다.

1. 애니메이션 시작 전에, 현재 나타나있는 child의 willMoveToParentViewController: nil을 호출합니다.
2. container에서 addChildViewController를 호출하여 새로운 child를 추가해 줍니다.
3. transition 애니메이션을 호출합니다.
4. 애니메이션 컴플리션에서 다음을 수행합니다
    - old child에서 removeFromParentViewController를 호출합니다
    - new child에서 didMoveToParentViewController를 호출합니다.

```swift
func replace(fromContent: UIViewController, toContent: UIViewController) {
    //1.
    fromContent.willMove(toParent: nil)
    
    //2.
    addChild(toContent)

    //3.
    transition(from: fromContent, to: toContent, duration: 0.25) {
      //do set frame
    } completion: { (_) in
      fromContent.removeFromParent()
      toContent.didMove(toParent: self)
    }
  }
```

### Managing Appearance Updates for Children

container에서는 appearance-related message를 child에 자동으로 전달합니다.

```swift
override var shouldAutomaticallyForwardAppearanceMethods: Bool {
  return true //default is true
}
```

다만 shouldAutomaticallyForwardAppearanceMethods를 오버라이드 해서 false로 변경하는 경우,

appearance-related message를 직접 전달해주어야 합니다.

```swift
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  children.forEach {
    $0.beginAppearanceTransition(true, animated: animated)
  }
}

override func viewDidAppear(_ animated: Bool) {
  super.viewDidAppear(animated)
  children.forEach {
    $0.endAppearanceTransition()
  }
}

override func viewWillDisappear(_ animated: Bool) {
  super.viewWillDisappear(animated)
  children.forEach {
    $0.beginAppearanceTransition(false, animated: animated)
  }
}

override func viewDidDisappear(_ animated: Bool) {
  super.viewDidDisappear(animated)
  children.forEach {
    $0.endAppearanceTransition()
  }
}
```

## Suggestions for Building a Container View Controller

custom container view controller 만들 때 고려할 것들

1. child view controller의 ui property중에서 root view에만 접근 하세요.
2. child는 container에 대해서 꼭 필요한 것만 알 수 있도록 하세요.

    child는 자신의 content displaying에 집중해야 합니다.

    만약에 container가 child에 영향을 받는 경우에는 델리게이트 패턴을 사용하세요.

3. Design your container using regular views first.

    When the regular views work as expected, swap them out for the views of your child view controllers.

## Delegating Control to a Child View Controller

container는 appearance에 관한 처리를 child에 위임할 수 있습니다.

1. container의 statusBar에 대한 처리를 child에 맡길 수 있습니다.

    ```swift
    override var childForStatusBarStyle: UIViewController? {
      return children.first
    }
    ```

    children.first.preferredStatusBarStyle에 따라 container의 statusBarStyle이 결정됩니다.

    ```swift
    override var childForStatusBarHidden: UIViewController? {
      return children.first
    }
    ```

    children.first.prefersStatusBarHidden에 따라 container statusBarHidden이 결정됩니다.

2. child에게 자신의 사이즈에 대한 결정을 맡길 수 있어요.

    child의 preferredContentSize 프로퍼티를 활용하면 됩니다.