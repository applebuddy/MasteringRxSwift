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
  private var articlesListViewModel: ArticleListViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    
    populateNews()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.self.articlesListViewModel == nil ? 0 : self.articlesListViewModel.articlesVM.count
  }
  
  private func populateNews() {
    let apiKey = "332061f95205453e87c5c53efeef93f8"
    let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")!
    let resource = Resource<ArticleResponse>(url: url)
    URLRequest.load(resource: resource) // -> Observable<ArticleResponse>
      .subscribe(onNext: { [weak self] articlesResponse in
        let articles = articlesResponse.articles
        self?.articlesListViewModel = ArticleListViewModel(articles)
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      }).disposed(by: disposeBag)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
      return UITableViewCell()
    }
    
    // ViewModel의 Observable 프로퍼티와 View를 바인딩하여 UI를 업데이트 시킬 수 있다.
    // asDriver, drive를 활용하면 onObserve 등으로 메인스레드 지정코드를 작성할 필요없이 보다 간결하게 코드를 작성 가능하다. drive는 기본적으로 메인스레드에서 동작하므로 UI 바인딩에 사용하면 유용하다.
    let articleVM = self.articlesListViewModel.articleAt(indexPath.row)
    articleVM.title.asDriver(onErrorJustReturn: "")
      .drive(cell.titleLabel.rx.text)
      .disposed(by: disposeBag)
    articleVM.description.asDriver(onErrorJustReturn: "")
      .drive(cell.descriptionLabel.rx.text)
      .disposed(by: disposeBag)
    
    return cell
  }
}
