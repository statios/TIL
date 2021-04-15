//
//  ViewController.swift
//  Practice_IPadFloatingKeyboardTest
//
//  Created by Stat on 2021/04/14.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {

  private var idTextField: UITextField!
  private var submitButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    idTextField = UITextField().then {
      $0.add(to: view)
      $0.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.leading.equalToSuperview().offset(16)
        make.trailing.equalToSuperview().offset(-16)
        make.height.equalTo(40)
      }
      $0.backgroundColor = .blue
    }
    
    submitButton = UIButton().then {
      $0.add(to: view)
      $0.snp.makeConstraints { (make) in
        make.leading.trailing.equalToSuperview()
        make.bottom.equalTo(view.keyboardLayoutGuideNoSafeArea.snp.top)
        make.height.equalTo(44)
      }
      $0.backgroundColor = .red
    }
    
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }

}

private extension UIView {
  func add(to: UIView) {
    to.addSubview(self)
  }
}
