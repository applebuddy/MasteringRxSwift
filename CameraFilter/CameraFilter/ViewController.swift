//
//  ViewController.swift
//  CameraFilter

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var applyFilterButton: UIButton!
  
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let navigationController = segue.destination as? UINavigationController,
          let photoCollectionViewController = navigationController.viewControllers.first as? PhotoCollectionViewController else {
      fatalError("Segue destination is not found")
    }
    // 선택한 이미지를 참고하기 위해 selectedPhoto Observable을 subscribe 합니다.
    // subscribe 함으로써 가장 최근에 선택한 image 정보를 감지할 수 있습니다.
    // PublishSubject를 활용하여 별도의 delegate를 구현하지 않고, PhotoCollectionViewController에서 선택한 이미지에 대한 정보를 받아 페이지에 띄울 수 있습니다.
    photoCollectionViewController.selectedPhoto.subscribe(onNext: { [weak self] photo in
      DispatchQueue.main.async {
        self?.updateUI(with: photo)
      }
    }).disposed(by: disposeBag)
  }
  
  @IBAction func applyFilterButtonPressed() {
    guard let sourceImage = self.photoImageView.image else {
      return
    }
    
    // observable way
    FilterService().applyFilter(to: sourceImage)
      .subscribe(onNext: { [weak self] filteredImage in
        DispatchQueue.main.async {
          self?.photoImageView.image = filteredImage
        }
      }).disposed(by: disposeBag)
    // non-observable way
    /*
    FilterService().applyFilter(to: sourceImage) { filteredImage in
      DispatchQueue.main.async {
        self.photoImageView.image = filteredImage
      }
    }
     */
  }
  
  private func updateUI(with image: UIImage) {
    self.photoImageView.image = image
    self.applyFilterButton.isHidden = false
  }
}
