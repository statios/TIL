# RxSwift 로 UIKit 애니메이션 체이닝하기

[https://www.toptal.com/ios/rxswift-animations-ios](https://www.toptal.com/ios/rxswift-animations-ios)

- UIKit에서 제공하는 UIView.animate()로 원하는 애니메이션을 구현하는 것은 어렵지 않다.
- 하지만 보통 여러 뎁스로 중첩된 클로저를 사용해야 하며 이로인해 가독성이 떨어지게 된다.
- 반응형 프레임워크인 RxSwift를 사용하여 클린 코드를 작성하고 가독성을 향상시킬 수 있다.

---

### 반응형 프로그래밍?

- 반응형 프로그래밍은 대부분의 모던 프로그래밍 언어에서 채택됨
- 반응형 프로그래밍이 무엇인지 그리고 왜그렇게 강력하다고 하는지는 검색을 해보면 알 수 있을것
- 무엇보다도 코드 복잡도를 단순화 해준다는 점이 이유다
- 비동기식 작업을 체이닝하여 선언적이며 읽기 쉬운 방식으로 표현할 수 있어서 좋다
- iOS 개발에서 대표적인 반응형 프로그래밍 툴을 제공하는 프레임워크는 RxSwift

---

### 기존의 애니메이션 구현 방식

- 운영중인 앱의 스플래시 애니메이션을 구현한 코드이다.

```swift
UIView.animate(withDuration: 1.0) {
    self.topView.snp.remakeConstraints { make in
        make.width.equalTo(74)
        make.height.equalTo(35)
        make.leading.equalTo(self.titleView.snp.leading)
        make.bottom.equalTo(self.titleView.snp.top).offset(-31)
    }
    self.leftView.snp.remakeConstraints { make in
        make.width.equalTo(16)
        make.height.equalTo(17)
        make.bottom.equalTo(self.titleView.snp.top).offset(-12)
        make.leading.equalTo(self.titleView.snp.leading)
    }
    self.rightView.snp.remakeConstraints { make in
        make.width.height.equalTo(17)
        make.trailing.equalTo(self.titleView).offset(2)
        make.bottom.equalTo(self.titleView.snp.top).offset(-12)
    }
    self.bottomView.snp.remakeConstraints { make in
        make.width.equalTo(37)
        make.height.equalTo(17)
        make.bottom.equalTo(self.titleView.snp.top).offset(-12)
        make.leading.equalTo(self.titleView.snp.leading).offset(18)
    }
    self.view.layoutIfNeeded()
}
```

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/uiview_animate.gif](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/uiview_animate.gif)

- uiview.animate의 completion 핸들러를 이용한다면 어떻게될까?

```swift
UIView.animate(withDuration: 0.5, animations: {
	//do something
}, completion: { _ in
	UIView. animate(withDuration: 0.5, animations: {
		//do something
	}, completion: { _ in 
		UIView.animate(withDuration: 0.5, anbmations: {
			//do something
		})
	})
})
```

- 클로저가 중첩되기 때문에 가독성이 떨어진다.
- 사실 이를 해결하기 위한 기능이 이미 존재한다 - animateKeyframes

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled.png)

장점

- 코드 들여 쓰기를 하지 않으므로 플랫하게 정렬됨
- 순서 변경이 간단하다

단점

- 각각의 애니메이션이 상대적인 타이밍에 의해 결정되는 것이 아니라 절대적 시점에 의존함
- 따라서 순서를 변경하기 위해서는 얽혀있는 모든 애니메이션의 시점을 계산해야함

따라서 앞으로의 해결 방법은 다음 조건을 충족해야한다

- 과도한 들여쓰기 없이 플랫한 줄맞춤이 유지되어야함
- 다른 애니메이션과 관계에서의 부작용없이 수정이 간단해야함, 추가, 제거가 쉬워야함 (독립적)

---

### RxSwift를 이용하여 애니메이션을 체이닝 코드로 구현

1. 각각의 애니메이션을 Observable<Void>를 리턴하는 함수로 래핑한다
2. Observable<Void>는 시퀀스가 종료되기 전에 이벤트를 한번 방출함
3. 해당 이벤트는 애니메이션 완료되었을때 발생
4. flatMap operator를 이용하여 여러 애니메이션 observable을 체이닝함

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%201.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%201.png)

- usage

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%202.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%202.png)

- rotate → shift → fade
- 이번에는 concat operator를 사용해보자

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%203.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%203.png)

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/2020-05-16_14-07-28.2020-05-16_14_08_09.gif](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/2020-05-16_14-07-28.2020-05-16_14_08_09.gif)

- delay 펑션을 정의해서

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%204.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%204.png)

- 딜레이를 줄 수도있다

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%205.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%205.png)

- 반복적으로 동작하는 애니메이션을 정의해보자

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%206.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%206.png)

create된 시퀀스가 dispose 될 때까지 animate() 함수가 계속해서 동작한다

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%207.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%207.png)

take 오퍼레이터를 사용해서 이벤트가 5번 발생하면 시퀀스를 종료시켰다. (concat은 이전 시퀀스가 종료해야 다음 시퀀스 받음)

따라서 titleView는 5번 rotate 애니메이션을 반복하고, shift, fade 한다

- 이번에는 이러한 메서드를 Rx 익스텐션을 통해 구현해보자.

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%208.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%208.png)

![RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%209.png](RxSwift%20%E1%84%85%E1%85%A9%20UIKit%20%E1%84%8B%E1%85%A2%E1%84%82%E1%85%B5%E1%84%86%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%89%E1%85%A7%E1%86%AB%20%E1%84%8E%E1%85%A6%E1%84%8B%E1%85%B5%E1%84%82%E1%85%B5%E1%86%BC%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%203ffa5dae96a84976b6ce7f6271bb6a68/Untitled%209.png)