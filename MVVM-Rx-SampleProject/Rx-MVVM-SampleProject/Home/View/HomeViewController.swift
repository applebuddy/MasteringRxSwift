//
//  HomeViewController.swift
//  Rx-MVVM-SampleProject
//
//  Created by Mohammad Zakizadeh on 9/27/18.
//  Copyright © 2018 storm. All rights reserved.
//
// sample project reference : https://medium.com/@mamalizaki74/practical-mvvm-rxswift-a330db6aa693

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
  // MARK: - UI
  
  // tracksVC가 들어갈 컨테이너 뷰
  @IBOutlet weak var tracksVCView: UIView!
  // albumsVC가 들어갈 컨테이너 뷰
  @IBOutlet weak var albumsVCView: UIView!
  
  private lazy var albumsViewController: AlbumsCollectionViewVC = {
    // Load Storyboard
    // 스토리보드로부터 AlbumCollectionViewVC를 불러온다.
    let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
    
    // Instantiate View Controller
    guard var viewController = storyboard.instantiateViewController(
      withIdentifier: String(describing: AlbumsCollectionViewVC.self)
    ) as? AlbumsCollectionViewVC else {
      return AlbumsCollectionViewVC()
    }
    
    // Add View Controller as Child View Controller
    // viewControler를 albumsVCView액자에 추가, 맞추는 작업
    self.add(asChildViewController: viewController, to: albumsVCView)
    return viewController
  }()
  
  private lazy var tracksViewController: TracksTableViewVC = {
    // Load Storyboard
    let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
    
    // Instantiate View Controller
    guard var viewController = storyboard.instantiateViewController(
      withIdentifier: String(describing: TracksTableViewVC.self)
    ) as? TracksTableViewVC else {
      return TracksTableViewVC()
    }
    
    // Add View Controller as Child View Controller
    // viewControler를 albumsVCView액자에 추가, 맞추는 작업
    self.add(asChildViewController: viewController, to: tracksVCView)
    return viewController
  }()
  
  // MARK: - Property
  
  // 비즈니스 로직이 포함되어있는 ViewModel 생성
  var homeViewModel = HomeViewModel()
  // 구독 정보 관리에 사용되는 DisposeBag()
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addBlurArea(area: self.view.frame, style: .dark)
    setupBindings()
    homeViewModel.requestData()
  }
  
  // MARK: - Bindings
  /// View ~ ViewModel 바인딩 작업
  private func setupBindings() {
    
    // binding loading to vc
    // bomViewModel의 loading 이벤트와 HomeVC의 isAnimating binding
    homeViewModel.loading
      .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
    
    // observing errors to show
    // ViewModel의 error PublishSubject에서 에러 이벤트를 방출하면, 이에 맞게 View가 반응하도록 binding
    homeViewModel
      .error
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { (error) in
        switch error {
        case .internetError(let message):
          MessageView.sharedInstance.showOnView(message: message, theme: .error)
        case .serverMessage(let message):
          MessageView.sharedInstance.showOnView(message: message, theme: .warning)
        }
      })
      .disposed(by: disposeBag)
    
    // binding albums to album container
    // viewModel의 albums data와 viewController의 album data를 바인딩, viewModel의 albums가 변경되면 viewController의 albums도 동일하게 변경된다.
    homeViewModel
      .albums
      .observe(on: MainScheduler.instance)
      .bind(to: albumsViewController.albums)
      .disposed(by: disposeBag)
    
    // binding tracks to track container
    // viewModel의 tracks data와 viewController의 album data를 바인딩, viewModel의 tracks가 변경되면 viewController의 tracks도 변경된다.
    homeViewModel
      .tracks
      .observe(on: MainScheduler.instance)
      .bind(to: tracksViewController.tracks)
      .disposed(by: disposeBag)
  }
}
