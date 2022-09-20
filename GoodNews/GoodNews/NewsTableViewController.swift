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
  
  private let disposeBag = DisposeBag()
  private var articles = [Article]()
  
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
        return try? JSONDecoder().decode(ArticlesList.self, from: data).articles
      }.subscribe(onNext: { [weak self] articles in
        guard let articles = articles else {
          return
        }
        DispatchQueue.main.async {
          self?.articles = articles
          self?.tableView.reloadData()
        }
      }).disposed(by: disposeBag)
  }
}

extension NewsTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.articles.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as? ArticleTableViewCell else {
      return UITableViewCell()
    }
    
    cell.titleLabel.text = self.articles[indexPath.row].title
    cell.descriptionLabel.text = self.articles[indexPath.row].description
    return cell
  }
}
