# ReactorKit

[ReactorKit/ReactorKit](https://github.com/ReactorKit/ReactorKit)

### Basic Concept

- 리액터킷은 Flux 와 Reactive Programming의 콤비네이션
- 유저 액션과 뷰의 상태가 각각의 레이어에 옵저버블 스트림으로 전달됨
- 이러한 스트림은 한쪽으로만 전달됨
- 뷰는 액션을 방출하고 리액터는 상태를 방출

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/image.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/image.png)

---

### Design Goal

- 테스트 가능성
    - 첫번째 목적은 비즈니스 로직을 뷰로부터 분리 하는것
    - 이것은 코드를 테스트 가능하게함
    - 리액터는 뷰에대해 의존성을 가지지 않음
    - 그냥 리액터를 테스트하구 뷰 바인딩을 테스트하면됨
- Start Small
    - 리액터킷은 전체 어플리케이션에 대해 단일한 아키텍쳐를 따르도록 요구하지 않음
    - 리액터킷은 뷰 단위로 부분적으로 채택될 수 있음
    - 리액터킷을 적용하기 위해서 전체 프로젝트 소스코드를 전부 수정할 필요가 없다
- Less Typing
    - 리액터킷은 복잡한 코드를 피할 수 있게함
    - 다른 아키텍쳐보다 적은 코드로 작성 가능

---

### View

- 뷰는 데이터를 보여주는 녀석이다.
- 뷰 컨트롤러와 셀도 뷰처럼 다룬다
- view 가 하는것?
    - User interaction → bind → action stream
    - view state → bind → UI Components
- 뷰 계층에서 비즈니스 로직은 읍다,..!
- 뷰는 그냥 Action stream과 state stream 을 어떻게 map하는지만 정의할 뿐임
- 뷰를 정의하기 위해서 View 프로토콜을 채택해야함
- 그러면 reactor 라는 프로퍼티가 자동으로 생성된다
- 이 reactor는 보통 view의 외부에서 set 함 이런식으루

    ![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled.png)

- reactor 프로퍼티가 변경되면 `bind(reactor:)` 가 호출된다
- `bind(reactor:)` 에다가 action stream , state stream 바인딩을 정의하면된다 이렇게

    ![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%201.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%201.png)

---

### Reactor

- 리액터는 UI로부터 독립적이다.
- 뷰의 상태를 관리한다
- 리액터의 가장 우선되는 역할은 control flow(탭 액션 등)를 뷰 로부터 분리하는 것임
- 모든 뷰는 대응하는 리액터를 가지는데 모든 로직에 대한 수행을 리액터에다가 위임하는 것이라 생각하자
- 리액터는 뷰에 대해 의존성이 없다 그렇기 때문에 테스트가 용이하다
- 먼저 리액터를 정의하기 위해서 `Reactor` 프로토콜을 채택한다
- 그러면 `Action` `Mutation` `State` 를 구현하라고 할 거다
- 그리고 `initialState` 프로퍼티를 정의해줘야 한다

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%202.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%202.png)

- `Action` 은 유저인터랙션을 나타낸다
- `State` 는 뷰의 상태를 나타낸다
- `Mutation` 은 Action과 State의 브릿지 역할을 한다
- 리액터는 두 단계를 거쳐서 action stream을 state stream로 변환한다. `mutate()` 와 `reduce()`

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/image%201.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/image%201.png)

`mutate()`

- receives an `Action` → generates an `Observable<Mutation>`

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%203.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%203.png)

- API 호출이나 비동기 연산 같은 모든 사이드 이펙트는 이 메서드에서 수행된다

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%204.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%204.png)

`reduce()`

- 기존 State와 Mutation 으로부터 새로운 State를 생성한다

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%205.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%205.png)

- 이 메서드는 순수 함수다. 새로운 State를 동기적으로 리턴한다
- 외부와 관련된 어떤 사이드 이펙트도 처리하지 않는다

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%206.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%206.png)

`transform()`

- 각각의 스트림을 변환시킨다. 종류가 세개 있다.

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%207.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%207.png)

- 여러 옵저버블 스트림을 변환시키고 결합하는 넘들이다.
- 예를 들면 두번째 메서드는 글로벌 이벤트 스트림을 mutation stream으로 바꿔주는 녀석
    - 여러 뷰가 하나의 상태를 공유해야하는 경우에 global state를 정의해서 공유할 수 있게 해준다
- 그리고 얘네들은 디버깅 목적으로 사용될 수도 있다. 이렇게. 하나 둘 셋 얍.

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%208.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%208.png)

---

### Global States

- 리액터킷은 글로벌 앱 상태를 정의하지 않는다 - 글로벌 앱 상태가 필수가 아님
- 바꿔말하면 글로벌 상태로 어떤 것이라도 쓸 수 있다
- BehaviorSubject, PublishSubject 심지어 리액터로도
- Action→Mutation→State 흐름으로 이어진즌 state는 존재하지 않는다
- transform(mutation:)을 이용하여 글로벌 state로 변환하여야 한다
- 유저 인증 정보를 저장하는 global BehaviorSubject가 있다고 해보자
    - currentUser가 변경되었을 때 Mutation.setUser(User?)를 emit 하고 싶다면

    ![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%209.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%209.png)

    - 뷰가 리액터로 액션을 보내서 currentUser가 변경될 때마다 mutation은 방출될것

---

### View Communication

- 여러 뷰와 커뮤니케이션 하기 위해서 그동안 델리게이트 패턴이나 콜백 클로져를 사용해왔다
- 리액터킷은 reactive extensions를 권장한다
- ControlEvent의 가장 보편적 예시는 UIButton.rx.tap이다
- 핵심 컨셉은 커스텀뷰를 UIButton 이나 UILabel 처럼 다루는 것임

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/image%202.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/image%202.png)

- 메시지들을 보여주는 ChatViewController를 가정해보자
    - ChatViewController는 MessageInputView를 소유함
    - 유저가 MessageInputView의 send button을 탭했을때 텍스트는 ChatViewController로 전달되고 ChatViewController는 리액터의 액션에 바인드함
    - 아래는 MessageInputView의 reactive extension

        ![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2010.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2010.png)

    - ChatViewController에서 아래처럼 사용하면됨

        ![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2011.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2011.png)

---

### Testing

- 리액터킷은 테스팅을 위한 기능이 내장되어 있다 (대단한걸)
- 뷰와 리액터 둘다 쉽게 테스트 할 수 있다
1. **무엇을 테스트할 것인가**
    - View
        - Action : 주어진 유저인터랙션에 대해 적절한 액션이 리액터로 전달되었는가?
        - State : 상태에 따라 뷰가 적절하게 바인딩 되었는가?
    - Reactor
        - State : 주어진 액션에 대해 state가 적절하게 변경되었는가?
2. **Views Testing**
    - stub reactor를 이용하여 테스트한다
    - 리액터는 액션을 프린트하고 하드하게 state 체인지를 할 수 있는 stub 프로퍼티를 가진다
    - stub 리액터의 isEnabled 가 true면 mutate()랑 reduce()는 작동하지 않음
    - stub은 이런 프로퍼티들을 가진다

    ![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2012.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2012.png)

    - 테스트 케이스를 맹글어 보자

    ![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2013.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2013.png)

3. **Reactor testing**
    - 리액터는 독립적으로 테스트 가능하다

    ![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2014.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2014.png)

    - 한번의 액션으로 state가 여러번 바뀌는 경우가 있다.
    - 예를들면 `.refresh` 액션은 state.isLoading을 true로 바꾼뒤 리프레시 완료 후 다시 false로 바꾼다.
    - 이런 케이스는  state.isLoading과 currentState를 테스트 하기 어렵고 RxTest 나 RxExpect를 이용해야할 수도 있다.
    - 아래는 RxExpect를 이용하여 이러한 케이스를 테스트 하는 코드이다

    ![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2015.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2015.png)

---

### Scheduling

- reducing 메서드와 state를 옵저빙하는 스트림이 어떤 스케쥴러에서 작동할지 정하기 위해서 `scheduler` 프로퍼티를 정의하면 된다
- 디폴트 스케줄러는 CurrentThreadScheduler 이다.

![ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2016.png](ReactorKit%20a7b743e968cb4a3ca92c19dfab5587a7/Untitled%2016.png)

---