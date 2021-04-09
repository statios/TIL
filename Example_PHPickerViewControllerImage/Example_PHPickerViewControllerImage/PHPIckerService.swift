//
//  PHPIckerService.swift
//  Example_PHPickerViewControllerImage
//
//  Created by Stat on 2021/04/09.
//

import Foundation
import PhotosUI
import RxSwift
import MobileCoreServices

protocol PHPickerServiceType {
  func parse(from results: [PHPickerResult]) -> Observable<[UIImage]>
}

class PHPickerService: PHPickerServiceType {
  
  func parse(from results: [PHPickerResult]) -> Observable<[UIImage]> {
    return Observable.create { [weak self] emitter in
      self?.parse(from: results) {
        emitter.onNext($0)
      }
      return Disposables.create()
    }
  }
  
}

extension PHPickerService {
  private func parse(
    from results: [PHPickerResult],
    completion: @escaping (([UIImage]) -> Void)
  ) {
    
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
      let images = selectedImageDatas.compactMap { $0 }.compactMap { UIImage(data: $0) }
      completion(images)
    }
  }
}
