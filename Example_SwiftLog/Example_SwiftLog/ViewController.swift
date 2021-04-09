//
//  ViewController.swift
//  Example_SwiftLog
//
//  Created by Stat on 2021/04/02.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    Log.debug("ViewController")
    Log.error("ViewController")
  }


}

