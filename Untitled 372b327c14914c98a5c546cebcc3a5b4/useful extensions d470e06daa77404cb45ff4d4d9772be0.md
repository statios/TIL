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