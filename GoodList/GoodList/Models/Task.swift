//
//  Task.swift
//  GoodList
//
//  Created by MinKyeongTae on 2022/09/19.
//

import Foundation

enum Priority: Int {
  case high
  case medium
  case low
}

struct Task {
  let title: String
  let priority: Priority
}
