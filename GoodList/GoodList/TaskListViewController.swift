//
//  TaskListViewController.swift
//  GoodList
//
//  Created by MinKyeongTae on 2022/09/19.
//

import UIKit
import RxSwift

class TaskListViewController: UIViewController {
  @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // RxSwift 활용, AddTaskViewController의 taskObservable을 구독해서 특정 Task를 저장할때 그 값을 전달받을 수 있도록 할 수 있다.
    guard let navigationController = segue.destination as? UINavigationController,
          let addViewController = navigationController.viewControllers.first as? AddTaskViewController else {
      fatalError("ViewController not found.....")
    }
    addViewController.taskSubjectObservable.subscribe(onNext: { task in
      // taskSubject 이벤트를 구독하여 taskSubject 이벤트가 발생할때 Task 모델 이벤트를 받아 처리할 수 있다.
      print(task)
    }).disposed(by: disposeBag)
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
