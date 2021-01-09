# Clean Swift iOS Architecture

[Clean Swift iOS Architecture for Fixing Massive View Controller](https://clean-swift.com/clean-swift-ios-architecture/)

- MVC, MVVM ReactiveCocoa 그리고 VIPER 같은 다양한 아키텍처를 testing and mocking 프레임웍에 대한 실험과 함께 조사하였다.
- Swift iOS project에서 Bob의 클린아키텍처를 적용하는 것에 주안을 두었다.
- 아래의 기대효과를 가진다
    - 쉽고 빠른 버그 수정
    - 기존 기능의 수정 용이성
    - 간단한 기능 추가
    - 단일 책임의 작은 메서드 작성
    - 객체 의존성 디커플링
    - ViewController의 비즈니스 로직을 Interactor에 정의
    - Workers, Service 객체를 이용한 reusable 컴포넌트 작성
    - 처음부터 factored 코드를 작성
    - 빠르고 지속가능한 유닛테스트 작성
    - regression을 캐치하기 위한 테스트에 자신감이 생길것
    - 프로젝트 규모에 상관없이 적용 가능

## The VIP Cycle

![Clean%20Swift%20iOS%20Architecture%20efcd6bde224e4ea1bf98f18b7b51f163/image.png](Clean%20Swift%20iOS%20Architecture%20efcd6bde224e4ea1bf98f18b7b51f163/image.png)

- VIP가 input/output하는 데이터 들은 커스텀 struct/class/enum을 사용할 수 있지만 이러한 객체의 내부에는 Int/String 같은 primitive type만 포함되어야 한다.

    이게 중요한게, 비즈니스 로직 변경이 있을 때 data model도 변경되기 때문이다.

- 기본적인 데이터 이동 시나리오
    1. ViewController 

        → 유저 인터랙션을 받는다 

        → request를 구성하여 interactor에 전달한다

    2. Interactor

        → 전달받은 request에 대한 동작을 수행한다.

        → response를 구성하여 presenter에 전달한다

    3. Presenter

        → 전달받은 response를 가공(format)한다.

        → ViewModel로 가공된 객체를 ViewController에 전달한다.

## ViewController