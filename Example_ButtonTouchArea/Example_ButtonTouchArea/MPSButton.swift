//
//  MPSButton.swift
//  Example_ButtonTouchArea
//
//  Created by Stat on 2021/03/29.
//

import UIKit

open class MPSButton: UIButton {
  /// 터치 영역을 확장합니다.
  public var hitOutset: CGFloat = 0

  /// 이미지와 타이틀 사이 간격을 지정합니다.
  public var imageTitleInset: CGFloat = 0 {
    didSet {
      let direction = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
      switch direction {
      case .leftToRight:
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageTitleInset)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleInset, bottom: 0, right: 0)
      case .rightToLeft:
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -imageTitleInset)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitleInset, bottom: 0, right: 0)
      @unknown default:
        break
      }
    }
  }

  open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let outRect = bounds.insetBy(dx: -hitOutset, dy: -hitOutset)
    if outRect.contains(point) {
      return self
    }

    return super.hitTest(point, with: event)
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let originalSize = super.sizeThatFits(size)
    if imageTitleInset != 0 {
      return .init(width: originalSize.width + imageTitleInset, height: originalSize.height)
    } else {
      return originalSize
    }
  }

  open override var intrinsicContentSize: CGSize {
    let originalSize = super.intrinsicContentSize
    if imageTitleInset != 0 {
      return .init(width: originalSize.width + imageTitleInset, height: originalSize.height)
    } else {
      return originalSize
    }
  }
}

