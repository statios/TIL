# setNeedsLayout vs layoutIfNeeded

[[ios] setNeedsLayout vs layoutIfNeeded](https://baked-corn.tistory.com/105)

### Main Run Loop & Update Cycle

- 앱 실행 시 `UIApplication`이 메인 스레드에서 **main run loop**를 실행
- **main run loop**는 루프를 돌면서 터치 이벤트, 위치의 변화, 디바이스 회전 등 각종 이벤트를 처리
    - 각 이벤트들에 알맞는 핸들러를 찾아 처리 권한을 위임하여 진행됨
- **update cycle -** 이벤트들을 모두 처리하고 권한이 다시 **main run loop**로 돌아오는 타이밍
- view의 layout이나 position은 **update cycle** 시점에 이루어짐 → '해당 코드를 읽는 시점 - 실제 반영' 사이의 시차가 존재

---

### layoutSubViews()

- `UIView` 내장 메소드
- view의 값을 호출한 즉시 변경시켜주는 메소드 → **update cycle** 에서만 호출됨
- 해당 `view`의 모든 `subview`의 `layoutSubViews()` 또한 연달아 호출됨 → 무거운 메소드라 직접 호출은 지양
- `layoutSubViews()`가 자동으로 호출되는 경우
    - view의 크기를 조절할 때
    - subview를 추가할 때
    - 사용자가 UIScrollView를 스크롤 할 때
    - 디바이스를 회전시켰을 때
    - view의 auto layout constraint 값을 변경했을 때
- `UIViewController` 내의 `View`가 재계산 되어 다시 그려지는 행위가 발생하면 (`layoutSubViews`가 호출되고 `view` 값이 갱신되고 나면) `UIViewController` 의 메소드인 `viewDidLayoutSubviews` 가 호출됨
- `UIViewController`의 `View`에 대한 `layoutSubViews`가 호출되고 나면 `UIViewController`의 메소드인 `viewDidLayoutSubviews`가 호출됨

---

### setNeedLayout()

- `UIView` 내장 메소드
- setrNeedLayout을 호출한 View는 재계산되어야 하는 View라고 수동으로 체크가 됨
- 체크된 View는 update cycle에서 layoutSubview가 호출됨
- 비동기적으로 작동됨 → 호출되고 바로 반환함 (view의 보여지는 모습은 update Cycle에서 들어갔을 때 바뀜)

---

### layoutIfNeeded()

- UIView 내장 메소드
- layoutSubviews를 동기적으로 즉시 실행시킴 - update cycle까지 기다리지 않는다
- main run loop 에서 하나의 view가 setNeedsLayout을 호출하고 layoutIfNeeded를 호출하면 layoutIfNeeded는 즉시 view에 반영되기 때문에 update cycle에서 setNeedsLayout에의해 호출되는 layoutSubview()는 호출되지 않는다 변경점이 없으므로