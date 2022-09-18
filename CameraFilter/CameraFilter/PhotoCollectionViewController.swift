//
//  PhotoCollectionViewController.swift
//  CameraFilter
//
//  Created by MinKyeongTae on 2022/09/18.
//

import UIKit
import Photos
import RxSwift

class PhotoCollectionViewController: UICollectionViewController {
  // review  : Subject는 Observable 이면서 동시에 Observer입니다. PublishSubject는 BehaviorSubject와 달리 초기값을 갖고 있지 않습니다.
  // selectedPhotoSubjet는 가장 최근 선택 된 UIImage를 갖게 될 것 입니다.
  private let selectedPhotoSubject = PublishSubject<UIImage>()
  var selectedPhoto: Observable<UIImage> {
    return selectedPhotoSubject.asObservable()
  }
  
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
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedAsset = self.images[indexPath.row]
    PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in
      guard let info = info else { return }
      // degraded image인지를 체크하고, degraded image가 아니면, selecedPhotoSubject에 해당 값을 설정한다.
      guard let isDegradedImage = info["PHImageResultIsDegradedKey"] as? Bool else { return }
      if !isDegradedImage {
        if let image = image {
          self?.selectedPhotoSubject.onNext(image)
          self?.dismiss(animated: true)
        }
      }
    }
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


