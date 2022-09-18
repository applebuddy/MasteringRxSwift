//
//  PhotoCollectionViewController.swift
//  CameraFilter
//
//  Created by MinKyeongTae on 2022/09/18.
//

import UIKit
import Photos

class PhotoCollectionViewController: UICollectionViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    populatePhotos()
  }
  
  private func populatePhotos() {
    PHPhotoLibrary.requestAuthorization { status in
      if status == .authorized {
        // access the photos from photo library
      }
    }
  }
}


