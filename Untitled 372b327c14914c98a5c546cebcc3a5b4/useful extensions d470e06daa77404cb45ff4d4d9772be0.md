# useful extensions

```jsx
extension String {
  var insertComma: String { let numberFormatter = NumberFormatter(); numberFormatter.numberStyle = .decimal // 소수점이 있는 경우 처리
    if let _ = self.range(of: ".") {
      let numberArray = self.components(separatedBy: ".")
      if numberArray.count == 1 {
        var numberString = numberArray[0]
        if numberString.isEmpty {
          numberString = "0"
        }
        
        guard let doubleValue = Double(numberString) else {
          return self
        }
        
        return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        
      } else if numberArray.count == 2 {
        var numberString = numberArray[0]
        if numberString.isEmpty {
          numberString = "0"
        }
        
        guard let doubleValue = Double(numberString) else {
          return self
        }
        
        return (numberFormatter.string(from: NSNumber(value: doubleValue)) ?? numberString) + ".\(numberArray[1])"
      }
    } else { guard let doubleValue = Double(self) else {
      return self
      }
      
      return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
    }
    return self
  }
}
```

```jsx
// Alert
extension Reactive where Base: UIViewController {
  func showAlert(
    message: String,
    title: String? = nil,
    style: UIAlertController.Style = .alert)
    -> Observable<Void> {
      return Observable.create { emitter in
        let alert = UIAlertController(
          title: title,
          message: message,
          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
          emitter.onNext(())
        }
        alert.addAction(okAction)
        self.base.present(alert, animated: true)
        return Disposables.create()
      }
  }
}

extension UIViewController {
  func showAlert(
    message: String,
    title: String? = nil,
    style: UIAlertController.Style = .alert,
    handler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
    alert.addAction(okAction)
    self.present(alert, animated: true)
  }
}
```