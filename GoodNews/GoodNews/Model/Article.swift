//
//  Article.swift
//  GoodNews
//
//  Created by MinKyeongTae on 2022/09/21.
//

import Foundation

struct ArticlesList: Decodable {
  let articles: [Article]
}

extension ArticlesList {
  static var all: Resource<ArticlesList> = {
    let apiKey = "332061f95205453e87c5c53efeef93f8"
    let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")!
    return Resource(url: url)
  }()
}

struct Article: Decodable {
  let title: String
  let description: String?
}
