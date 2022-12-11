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
  
  private lazy var albumsViewController: AlbumsCollectionViewController = {
    // Load Storyboard
    // 스토리보드로부터 AlbumCollectionViewVC를 불러온다.
    let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
    
    // Instantiate View Controller
    guard var viewController = storyboard.instantiateViewController(
      withIdentifier: String(describing: AlbumsCollectionViewController.self)
    ) as? AlbumsCollectionViewController else {
      return AlbumsCollectionViewController()
    }
    
    // Add View Controller as Child View Controller
    // viewControler를 albumsVCView액자에 추가, 맞추는 작업
    self.add(asChildViewController: viewController, to: albumsVCView)
    return viewController
  }()
  
  private lazy var tracksViewController: TracksTableViewController = {
    // Load Storyboard
    let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
    
    // Instantiate View Controller
    guard var viewController = storyboard.instantiateViewController(
      withIdentifier: String(describing: TracksTableViewController.self)
    ) as? TracksTableViewController else {
      return TracksTableViewController()
    }
    
    // Add View Controller as Child View Controller
    // viewControler를 albumsVCView액자에 추가, 맞추는 작업
    self.add(asChildViewController: viewController, to: tracksVCView)
    return viewController
  }()
  
  // MARK: - Property
  
  /// 비즈니스 로직이 포함되어있는 ViewModel, 내부의 subject observable은 View의 UI와 binding 된다.
  private var homeViewModel = HomeViewModel()
  // 구독 정보 관리에 사용되는 DisposeBag()
  private let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addBlurArea(area: self.view.frame, style: .dark)
    bindUI()
    homeViewModel.requestData()
  }
  
  // MARK: - Bindings
  /// HomeViewModel의 subject observable과 view UI를 binding
  private func bindUI() {
    
    // binding loading
    // bomViewModel의 loading 이벤트와 HomeVC의 isAnimating binding
    // loading 이벤트 bool 값에 따라 indicator가 동작
    homeViewModel
      .loadingSubject
      .bind(to: rx.isAnimating).disposed(by: disposeBag)
    
    // observing errors to show
    // ViewModel의 error PublishSubject에서 에러 이벤트를 방출하면, 이에 맞게 View가 반응하도록 binding
    // Error 이벤트를 받으면 그에 맞는 메세지를 띄운다.
    homeViewModel
      .errorSubject
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
      .albumsSubject
      .observe(on: MainScheduler.instance)
      .bind(to: albumsViewController.albumsSubject)
      .disposed(by: disposeBag)
    
    // binding tracks to track container
    // viewModel의 tracks data와 viewController의 album data를 바인딩, viewModel의 tracks가 변경되면 viewController의 tracks도 변경된다.
    homeViewModel
      .tracksSubject
      .observe(on: MainScheduler.instance)
      .bind(to: tracksViewController.tracksSubject)
      .disposed(by: disposeBag)
  }
}
