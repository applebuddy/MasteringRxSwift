//
//  ArticleViewModel.swift
//  NewsMVVMApp
//
//  Created by MinKyeongTae on 2022/09/24.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

struct ArticleListViewModel {
  let articlesVM: [ArticleViewModel]
}

extension ArticleListViewModel {
  init(_ articles: [Article]) {
    self.articlesVM = articles.compactMap(ArticleViewModel.init)
  }
}

extension ArticleListViewModel {
  func articleAt(_ index: Int) -> ArticleViewModel {
    return self.articlesVM[index]
  }
}

struct ArticleViewModel {
  let article: Article
  
  init(_ article:  Article) {
    self.article = article
  }
}

extension ArticleViewModel {
  // 1) Rxswift, RxCocoa 사용할때 바인딩할 Observable 변수
  /*
  var title: Observable<String> {
    return Observable<String>.just(article.title)
  }
  
  var description: Observable<String> {
    return Observable<String>.just(article.description ?? "")
  }
   */
  
  // 2) Combine 사용할때 바인딩할 Publisher 변수
  var title: AnyPublisher<String?, Never> {
    return Just(article.title)
      .eraseToAnyPublisher()
  }
  
  var description: AnyPublisher<String?, Never> {
    return Just(article.description)
      .eraseToAnyPublisher()
  }
}
