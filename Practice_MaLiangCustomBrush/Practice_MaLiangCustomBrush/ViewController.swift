//
//  ViewController.swift
//  Practice_MaLiangCustomBrush
//
//  Created by KIHYUN SO on 2021/03/05.
//

import UIKit
import MaLiang

class ViewController: UIViewController {

  @IBOutlet weak var canvas: Canvas!
    
  @IBAction func tappedClearButton(_ sender: Any) {
    canvas.clear()
  }
  
  @IBAction func tappedBrushSegment(_ sender: Any) {
    let segmentedControl = sender as! UISegmentedControl
    let selectedIndex = segmentedControl.selectedSegmentIndex
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let path = Bundle.main.path(forResource: "watercolor", ofType: "png")!
    let pencil = try? canvas.registerBrush(from: URL(fileURLWithPath: path))
    pencil?.pointSize = 62
    pencil?.use()
    
  }


}

