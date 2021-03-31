//
//  ViewController.swift
//  Example_ButtonTouchArea
//
//  Created by Stat on 2021/03/29.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var filterButton: MPSButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //1
    filterButton.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    
    //2
//    filterButton.hitOutset = 8
  }
  
  @IBAction func tappedFilterButton(_ sender: Any) {
    print("Tapped Filter Button")
  }
  
}

