//
//  CustomContainerViewController.swift
//  Example_CustomContainerViewController
//
//  Created by KIHYUN SO on 2021/02/22.
//

import Foundation
import UIKit

class CustomContainerViewController: UIViewController {
  
  override var shouldAutomaticallyForwardAppearanceMethods: Bool {
    return false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNeedsStatusBarAppearanceUpdate()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    children.forEach {
      $0.beginAppearanceTransition(true, animated: animated)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    children.forEach {
      $0.endAppearanceTransition()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    children.forEach {
      $0.beginAppearanceTransition(false, animated: animated)
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    children.forEach {
      $0.endAppearanceTransition()
    }
  }
  
  func displayContentViewControllers(contents: [UIViewController]) {
    let height = UIScreen.main.bounds.height / CGFloat(contents.count)
    contents.enumerated().forEach {
      //1.
      addChild($0.element)
      
      //2.
      view.addSubview($0.element.view)
      
      //3.
      $0.element.view.translatesAutoresizingMaskIntoConstraints = false
      $0.element.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      $0.element.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      $0.element.view.topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: height * CGFloat($0.offset)
      ).isActive = true
      $0.element.view.heightAnchor.constraint(equalToConstant: height).isActive = true
      
      //4.
      $0.element.didMove(toParent: self)
    }
  }
  
  func removeContentViewController(content: UIViewController) {
    //1.
    content.willMove(toParent: nil)
    
    //2.
    content.view.removeConstraints(content.view.constraints)
    
    //3.
    content.view.removeFromSuperview()
    
    //4.
    content.removeFromParent()
  }
  
  func replace(fromContent: UIViewController, toContent: UIViewController) {
    //1.
    fromContent.willMove(toParent: nil)
    
    //2.
    addChild(toContent)

    //3.
    transition(from: fromContent, to: toContent, duration: 0.25) {
      //do set frame
    } completion: { (_) in
      fromContent.removeFromParent()
      toContent.didMove(toParent: self)
    }
  }
  
  override var childForStatusBarStyle: UIViewController? {
    print("childForStatusBarStyle")
    return children.first
  }
  
  override var childForStatusBarHidden: UIViewController? {
    print("childForStatusBarHidden")
    return children.first
  }
}
