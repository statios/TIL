# Defining Your Subclass

## Handling User Interactions

ViewController가 responder object이긴하지만, 터치 이벤트를 직접받아서 처리하는 경우는 잘 없습니다.

ViewController가 이벤트를 처리하는 방법을 알아봅시다.

- higher-level event를 처리하기 위한 action method를 정의합니다.
- 다른 객체나 system에서 전송되는 notifications을 관찰합니다.
- 다른 객체의 DataSource 또는 Delegate 역할을 합니다.

## Displaying Your Views at Runtime

UIKit이 Runtime에 스토리보드로부터 views를 로드하는 과정

1. 스토리보드 파일의 정보를 이용해서 views를 instantiate한다
2. 모든 outlets 과 actions를 연결한다
3. root view를 viewController의 view 프로퍼티에 할당한다.
4. awakeFromNib 메서드를 호출한다.

    이 시점에서는 ViewController의 trait 정보가 없는 상태이므로, 

    views가 최종적인 모습이 아닐수도 있습니다.

5. viewDidLoad 메서드를 호출한다.

    여기서 add or removes views, modify layout constraints and load data 하면됩니다.

이후에 ViewController의 views가 화면에 나타나기 전에, UIKit은 아래의 작업을 처리합니다

1. viewWillAppear
2. update layout of the views
3. display the views on screen
4. viewDidAppear

views의 size or position을 추가, 제거 또는 수정하는 경우에,

그 views에 적용된 constraints도 추가 또는 제거하여야 합니다.

view hierarchy에 레이아웃 관련된 변화를 주면 UIKit은 layout을 dirty하게 표시합니다.

다음 업데이트 사이클 동안에, 레이아웃 엔진은 현재 레이아웃 제약에 따라 사이즈나 위치를 계산하고,

view hierarchy에 변화를 적용합니다.

## Managing View Layout

views의 위치와 크기가 변경되면, UIKit은 view hierarchy의 레이아웃 정보를 업데이트 합니다.

이때 오토레이아웃을 사용하여 구성된 views라면 현재 제약 조건에 따라 업데이트 하게됩니다.

또한 active presentation controller 같은 다른 관련 객체에 레이아웃 변경을 알려줍니다.

레이아웃 처리 과정의 여러 지점에서, 추가 작업을 수행할 수 있도록 알려줍니다.

그러면 레이아웃이 업데이트되는 과정을 알아보겠습니다.

1. Updates the trait collections of the view controller and its views, as needed
2. ViewController의 **viewWillLayoutSubviews** 메서드를 호출합니다.

    기본 구현에서는 아무 동작도 없습니다 그냥 notification 용도에요.

3. ViewController의 **containerViewWillLayoutSubviews** 메서드를 호출합니다.

    container view의 views가 변경되기 전에 호출됩니다.

4. ViewController의 **layoutSubviews** 메서드를 호출합니다.

    새로운 레이아웃 정보를 계산합니다.

    그런 다음에 view hierarchy에 포함된 subviews들을 순회하면서 `layoutSubviews` 를 호출합니다.

    이 메서드는 직접적으로 호출해서는 안되고, 강제로 레이아웃을 업데이트 시키고 싶으면 

    1. setNeedslayout() — 다음 업데이트때 반영
    2. layoutIfNeeded() — 지금 즉시 업데이트

    를 호출하시기 바랍니다.

5. 계산된 레이아웃 정보를 적용합니다.
6. ViewController의 **viewDidLayoutSubviews** 메서드를 호출합니다.
7. ViewController의 **containerViewDidLayoutSubviews** 메서드를 호출합니다.

layout을 효과적으로 관리하는 tips를 알아봅시다.

- **오토레이아웃을 사용하세요**
- **top and bottom layout guide를 활용하세요.**

    top layout guide는 status bar나 navigationBar를 고려한 레이아웃 지정을 돕습니다.

    bottom layout guide는 tabBar나 toolBar를 고려한 레이아웃 지정을 돕습니다.

- **view를 add or remove할 때는 제약 조건도 업데이트 해주세요.**
- **애니메이션이 동작하는 동안에는 제약조건을 잠시 제거해주세요.**

    애니메이션이 시작할때 제약조건을 제거하고 종료할 때 다시 추가해주시기 바랍니다.

    애니메이션 도중에 위치나 크기가 바뀐 경우 제약 조건을 업데이트 해주세요.

## Managing Memory Efficiently

- **init**
    - ViewController에 필요한 중요한 데이터 구조를 할당합니다.
- **viewDidLoad**
    - view에 display할 데이터를 할당하거나 load합니다.
- **didReceiveMemoryWarning**
    - low-memory notifications에 대응합니다.
    - 그리 중요하지 않은 객체를 메모리 해제합니다.
- dealloc
    - ViewController에 필요한 중요한 데이터 구조를 release합니다.
    - 시스템에서 인스턴스 변수들을 자동으로 release하므로 명시적으로 표시할 필요는 없어요.