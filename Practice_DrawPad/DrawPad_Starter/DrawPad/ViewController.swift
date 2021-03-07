import UIKit

class ViewController: UIViewController {
  
  // 지금까지의 모든 드로잉을 잡고있음
  @IBOutlet weak var mainImageView: UIImageView!
  
  // 현재 드로잉하는 선을 잡고있음
  @IBOutlet weak var tempImageView: UIImageView!
  
  // MARK: - Actions
  
  @IBAction func resetPressed(_ sender: Any) {
  }
  
  @IBAction func sharePressed(_ sender: Any) {
  }
  
  @IBAction func pencilPressed(_ sender: UIButton) {
  }
  
  // MARK: - Properties
  
  // 드로잉 할 때마다 위치값 저장
  var lastPoint = CGPoint.zero
  
  // 현재 선택된 브러시 색상
  var color = UIColor.black
  
  // 현재 선택된 브러시 두께
  var brushWidth: CGFloat = 10.0
  
  // 현재 선택된 브러시 투명도
  var opacity: CGFloat = 1.0
  
  // 브러시가 계속해서 입력되고 있는 동안 true
  var swiped = false
  
  // UIResponder에 정의된 메서드 - UIViewController에서 상속
  // 사용자가 화면에 터치했을 때 호출된다. -> 드로잉 시작시점 확인
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = false // 터치가 이동하지 않았기 때문에 일단 false
    lastPoint = touch.location(in: view) // 드로잉 위치 추적을 위해서 할당
  }
  
  /// 현재 입력되고 있는 두 포인트 간의 선을 그리는 메서드
  /// - Parameters:
  ///   - fromPoint: 시작 포인트
  ///   - toPoint: 종료 포인트
  func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    //1
    UIGraphicsBeginImageContext(view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    tempImageView.image?.draw(in: view.bounds)
    
    // 2
    context.move(to: fromPoint)
    context.addLine(to: toPoint)
    
    // 3
    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setLineWidth(brushWidth)
    context.setStrokeColor(color.cgColor)
    
    // 4
    context.strokePath()
    
    // 5
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    UIGraphicsEndImageContext()
  }
  
  // 사용자가 터치 입력후 드래그할때마다 호출
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    
    // 6
    swiped = true
    let currentPoint = touch.location(in: view)
    drawLine(from: lastPoint, to: currentPoint)
    
    // 7
    lastPoint = currentPoint
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped {
      drawLine(from: lastPoint, to: lastPoint)
    }
    
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    tempImageView.image = nil
  }
  
}

