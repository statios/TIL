//
//  ViewController.swift
//  Example_OpenPaymentsAtSettings
//
//  Created by Stat on 2021/04/22.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func tappedPayments(_ sender: Any) {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
        print("Settings opened: \(success)") // Prints true
      })
    }
  }
  
}

/*
 https://hanulyun.medium.com/리젝-앱스토어-리젝-app-prefs-root-general-사용-645cba96824f
 설정에서 각 항목으로 이동하는 URL 스킴을 사용하면 리젝, 설정<- 까지만 이동 가능
 */
