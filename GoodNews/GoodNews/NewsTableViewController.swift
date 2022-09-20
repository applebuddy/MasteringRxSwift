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
    // ArticlesList.all을 사용하면 아래 3줄 라인 코드를 사용할 필요가 없어져요.
//    let apiKey = "332061f95205453e87c5c53efeef93f8"
//    let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")!
//    let resource = Resource<ArticlesList>(url: url)
    
    // 제네릭 구조체를 받아서 구독 가능한 Observable로 변환 후 구독
    // 아래와 같이 어디서든 extension으로 구현한 URLRequest.load 메서드를 사용하면 원하는 데이터를 요청해서 수신한 값을 구독하여 업데이트할 수 있습니다.
    URLRequest.load(resource: ArticlesList.all)
      .subscribe(onNext: { [weak self] result in
        if let result = result {
          self?.articles = result.articles
          DispatchQueue.main.async {
            self?.tableView.reloadData()
          }
        }
      }).disposed(by: disposeBag)
    
    // rx. 를 접근해서 RxCocoa extension 기능을 사용 가능합니다. (ex) URLSession.shared.rx.data는 Observable<Data>를 반환)
//    Observable.just(url) // -> Observable<URL>
//      .flatMap { url -> Observable<Data> in
//        let request = URLRequest(url: url)
//        return URLSession.shared.rx.data(request: request) // -> Observable<Data>
//      }.map { data -> [Article]? in
//        return try? JSONDecoder().decode(ArticlesList.self, from: data).articles
//      }.subscribe(onNext: { [weak self] articles in
//        guard let articles = articles else {
//          return
//        }
//        DispatchQueue.main.async {
//          self?.articles = articles
//          self?.tableView.reloadData()
//        }
//      }).disposed(by: disposeBag)
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
