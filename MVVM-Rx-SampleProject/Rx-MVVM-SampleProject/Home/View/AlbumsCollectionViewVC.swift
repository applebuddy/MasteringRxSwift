//
//  AlbumsCollectionViewVC.swift
//  Storm
//
//  Created by Mohammad Zakizadeh on 7/21/18.
//  Copyright © 2018 Storm. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumsCollectionViewVC: UIViewController {
  // MARK: - UI

  @IBOutlet private weak var albumsCollectionView: UICollectionView!
  
  // MARK: - Property

  /// UICollectionView와 바인딩 되는 albums PublisherSubject
  public var albums = PublishSubject<[Album]>()
  private let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBinding()
    albumsCollectionView.backgroundColor = .clear
  }
  
  // MARK: - Configuration

  private func setupBinding() {
    albumsCollectionView.register(
      UINib(nibName: String(describing: AlbumsCollectionViewCell.self), bundle: nil),
      forCellWithReuseIdentifier: String(describing: AlbumsCollectionViewCell.self)
    )

    albums.bind(to: albumsCollectionView.rx.items(
      cellIdentifier: String(describing: AlbumsCollectionViewCell.self),
      cellType: AlbumsCollectionViewCell.self)
    ) { (row, album, cell) in
      cell.album = album
      cell.withBackView = true
    }.disposed(by: disposeBag)

    albumsCollectionView.rx.willDisplayCell
      .subscribe(onNext: ({ (cell,indexPath) in
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
          cell.alpha = 1
          cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
      })).disposed(by: disposeBag)
  }
}
