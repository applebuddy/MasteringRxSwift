//
//  NewsTableViewController.swift
//  GoodNews
//
//  Created by MinKyeongTae on 2022/09/21.
//

import RxSwift
import RxCocoa
import UIKit

class NewsTableViewController: UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.prefersLargeTitles = true
    
    populateNews()
  }
  
  private func populateNews() {
    let apiKey = "332061f95205453e87c5c53efeef93f8"
    let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")!
    // rx. 를 접근해서 RxCocoa extension 기능을 사용 가능합니다. (ex) URLSession.shared.rx.data는 Observable<Data>를 반환)
    Observable.just(url) // -> Observable<URL>
      .flatMap { url -> Observable<Data> in
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request) // -> Observable<Data>
      }.map { data -> [Article]? in
        return try? JSONDecoder().decode(ArticleList.self, from: data!.articles)
      }.subscribe(onNext: { [weak self] articles in
        if let articles = articles {
          DispatchQueue.main.async {
            self?.tableView.reloadData()
          }
        }
      })
  }
}
