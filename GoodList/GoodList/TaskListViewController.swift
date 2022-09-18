//
//  TaskListViewController.swift
//  GoodList
//
//  Created by MinKyeongTae on 2022/09/19.
//

import UIKit

class TaskListViewController: UIViewController {
  @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskTableViewCell.self), for: indexPath) as? TaskTableViewCell else {
//      return UITableViewCell()
//    }
//
//    return cell
    return UITableViewCell()
  }
}
