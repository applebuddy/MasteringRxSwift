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

struct Article: Decodable {
  let title: String
  let description: String
}
