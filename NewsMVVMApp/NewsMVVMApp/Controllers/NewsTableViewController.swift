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
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    
    populateNews()
  }
  
  private func populateNews() {
    let apiKey = "332061f95205453e87c5c53efeef93f8"
    let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")!
    let resource = Resource<ArticleResponse>(url: url)
    URLRequest.load(resource: resource) // -> Observable<ArticleResponse>
      .subscribe(onNext: {
        print($0) // ArticleResponse
      }).disposed(by: disposeBag)
  }
}
