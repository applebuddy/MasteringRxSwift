//
//  PhotoCollectionViewController.swift
//  CameraFilter
//
//  Created by MinKyeongTae on 2022/09/18.
//

import UIKit
import Photos

class PhotoCollectionViewController: UICollectionViewController {
  
  private var images = [PHAsset]()

  override func viewDidLoad() {
    super.viewDidLoad()
    populatePhotos()
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self), for: indexPath) as? PhotoCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let asset = self.images[indexPath.row]
    let manager = PHImageManager.default()
    manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
      DispatchQueue.main.async {
        cell.photoImageView.image = image
      }
    }
    return cell
  }
  
  private func populatePhotos() {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      if status == .authorized {
        // access the photos from photo library
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects { (object, count, stop) in
          self?.images.append(object)
        }
        
        self?.images.reverse()
        print(self?.images ?? [])
        DispatchQueue.main.async {
          self?.collectionView.reloadData()
        }
      }
    }
  }
}


