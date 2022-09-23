//
//  Article.swift
//  NewsMVVMApp
//
//  Created by MinKyeongTae on 2022/09/24.
//

import Foundation

struct ArticleResponse: Decodable {
  let articles: [Article]
}

struct Article: Decodable {
  let title: String
  let description: String?
}
