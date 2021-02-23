//
//  ViewController.swift
//  Example_CustomContainerViewController
//
//  Created by KIHYUN SO on 2021/02/22.
//

import UIKit

class CustomViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    print("called preferredStatusBarStyle in content view controller")
    return .darkContent
  }
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func tappedButton(_ sender: Any) {
    let firstContentViewController = CustomViewController()
    let secondContentViewController = UIViewController()
    let thirdContentViewController = UIViewController()
    
    firstContentViewController.view.backgroundColor = .red
    secondContentViewController.view.backgroundColor = .blue
    thirdContentViewController.view.backgroundColor = .orange
    
    let customContainerViewController = CustomContainerViewController()
    customContainerViewController.displayContentViewControllers(
      contents: [
        firstContentViewController,
        secondContentViewController,
        thirdContentViewController
      ]
    )
    
    present(customContainerViewController, animated: true)
  }
  
}

