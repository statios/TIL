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

class ViewController: UIViewController {

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
    
    picker.dismiss(animated: true)
    
    let dispatchQueue = DispatchQueue(
      label: "com.statios.Example-PHPickerViewControllerImage.AlbumImageQueue"
    )
    let dispatchGroup = DispatchGroup()
    var selectedImageDatas = [Data?](repeating: nil, count: results.count)
    var totalConversionsCompleted = 0
    
    for (index, result) in results.enumerated() {
      
      dispatchGroup.enter()
      
      result.itemProvider.loadFileRepresentation(
        forTypeIdentifier: UTType.image.identifier
      ) { (url, error) in
        
        guard let url = url else {
          dispatchQueue.sync { totalConversionsCompleted += 1 }
          return
        }
        
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let source = CGImageSourceCreateWithURL(url as CFURL, sourceOptions) else { dispatchQueue.sync { totalConversionsCompleted += 1 }
          return
        }
        
        let downsampleOptions = [
          kCGImageSourceCreateThumbnailFromImageAlways: true,
          kCGImageSourceCreateThumbnailWithTransform: true,
          kCGImageSourceThumbnailMaxPixelSize: 2_000,
        ] as CFDictionary
        
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else {
          dispatchQueue.sync { totalConversionsCompleted += 1 }
          return
        }
        
        let data =  NSMutableData()
        
        guard let imageDestination = CGImageDestinationCreateWithData(
                data, kUTTypeJPEG, 1, nil) else {
          dispatchQueue.sync { totalConversionsCompleted += 1 }
          return
        }
        
        let isPNG: Bool = {
          guard let utType = cgImage.utType else { return false }
          return (utType as String) == UTType.png.identifier
        }()
        
        let destinationProperties = [
          kCGImageDestinationLossyCompressionQuality: isPNG ? 1.0 : 0.75
        ] as CFDictionary
        
        CGImageDestinationAddImage(imageDestination, cgImage, destinationProperties)
        CGImageDestinationFinalize(imageDestination)
        
        dispatchQueue.sync {
          selectedImageDatas[index] = data as Data
          totalConversionsCompleted += 1
          dispatchGroup.leave()
        }
        
      }
    }
    
    dispatchGroup.notify(queue: .main) {
      print(selectedImageDatas.compactMap { $0 }.map { UIImage(data: $0) })
    }
    
  }
}

