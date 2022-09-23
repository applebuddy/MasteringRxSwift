//
//  NewsTableViewController.swift
//  NewsMVVMApp
//
//  Created by MinKyeongTae on 2022/09/24.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
}
