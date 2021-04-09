//
//  ViewController.swift
//  Example_PHPickerViewControllerImage
//
//  Created by Stat on 2021/04/09.
//
//  https://christianselig.com/2020/09/phpickerviewcontroller-efficiently/

import UIKit
import PhotosUI
import MobileCoreServices
import RxSwift

class ViewController: UIViewController {

  var disposeBag = DisposeBag()
  
  let phpickerService = PHPickerService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func tappedPickerButton(_ sender: Any) {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.preferredAssetRepresentationMode = .current
    configuration.selectionLimit = 8
    
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    present(picker, animated: true)
  }
  
}

extension ViewController: PHPickerViewControllerDelegate {
  func picker(
    _ picker: PHPickerViewController,
    didFinishPicking results: [PHPickerResult]) {
    
    phpickerService
      .parse(from: results)
      .subscribe()
      .disposed(by: disposeBag)
    
    picker.dismiss(animated: true)
  }
}

