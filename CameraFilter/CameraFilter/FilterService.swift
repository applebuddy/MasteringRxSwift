//
//  FilterService.swift
//  CameraFilter
//
//  Created by MinKyeongTae on 2022/09/18.
//

import Foundation
import UIKit
import CoreImage

class FilterService {
  // CI : CoreImage
  private var context: CIContext
  
  init() {
    self.context = CIContext()
  }
  
  /// 선택한 사진에 필터효과를 입힌 후 결과 이미지를 completion Handler로 반환하는 메서드
  func applyFilter(to inputImage: UIImage, completion: @escaping((UIImage) -> Void)) {
    let filter = CIFilter(name: "CICMYKHalftone")!
    filter.setValue(5.0, forKey: kCIInputWidthKey)
    
    if let sourceImage = CIImage(image: inputImage) {
      filter.setValue(sourceImage, forKey: kCIInputImageKey)
      
      if let cgImage = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
        let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
        // 아래 unobservable 한 방식으로 필터 이미지 결과를 띄울수도 있지만, 이 외에도 reactive 기반의 방법을 사용할 수 있다.
        completion(processedImage)
      }
    }
  }
}
