# Closure

## Capturing Values

클로져는 외부 context에 정의된 상수나 변수를 캡쳐할 수 있습니다.

상수와 변수를 정의했던 원래 범위가 더이상 존재하지 않더라도 

클로져 내부에서 이러한 상수와 변수의 값을 참조하고 수정할 수 있습니다.

Capturing Values의 가장 간단한 형태는 함수 내부에 또다른 함수가 선언된 경우입니다.

내부 함수에서 외부 함수의 파라미터나 상수/변수를 캡쳐하여 사용할 수 있습니다.

```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
  var runningTotal = 0
  func incrementer() -> Int {
    runningTotal += amount
    return runningTotal
  }
  return incrementer
}
```

내부 함수인 incrementer에서 runningTotal, amount 그리고 runningTotal을 참조할 수 있는 것은

외부 함수인 makeIncrementer의 파라미터와 변수를 캡쳐하였기 때문입니다.

따라서 runningTotal, amount 그리고 runningTotal은

1. makeIncrementer 함수가 종료 하더라도 사라지지 않습니다.
2. incrementer가 여러번 호출되더라도 동일한 runningTotal을 사용할 수 있습니다.

> 클로저에 의해 값이 변경되지 않고 클로저가 생성된 후 값이 변경되지 않는 경우에는 값의 복사본을 캡처하여 저장할 수 있습니다.
또한 Swift는 변수가 더이상 필요하지 않을 때 소멸하는 것과 같은 모든 메모리 관리를 내부적으로 처리합니다.

```swift
let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen() //10
incrementByTen() //20
incrementByTen() //30

let incrementBySeven = makeIncrementer(forincrement: 7)
incrementBySeven() //7

incrementByTen() //40
```