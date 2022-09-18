//
//  TaskListViewController.swift
//  GoodList
//
//  Created by MinKyeongTae on 2022/09/19.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
  @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  
  // 저장된 Task의 상태를 저장하는데 BehaviorRelay를 사용할 수 있다.
  // 기존 유사한 기능을 담당하는 Variable이 있었으나, 현재는 Deprecated되어 사용 못하는 듯 하다. (22년 9월 19일 기준)
  // -> Udemy 강의에서도 "'Variable' is planned for future deprecation. please consider 'BehaviorRelay' as a replacement. ..... 문구를 다루고 있음"
  private var tasks = BehaviorRelay<[Task]>(value: [])
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
    addViewController.taskSubjectObservable.subscribe(onNext: { [weak self] task in
      guard let self = self else { return }
      // taskSubject 이벤트를 구독하여 taskSubject 이벤트가 발생할때 Task 모델 이벤트를 받아 처리할 수 있다.
      print(task)
      self.tasks.accept(self.tasks.value + [task])
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
