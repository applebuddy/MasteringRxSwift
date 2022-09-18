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
  // * 기존 유사한 기능을 담당하는 Variable이 있었으나, 현재는 Deprecated되어 사용 못하는 듯 하다. (22년 9월 19일 기준)
  // -> Udemy 강의에서도 "'Variable' is planned for future deprecation. please consider 'BehaviorRelay' as a replacement. ..... 문구를 다루고 있음"
  // * BehaviorRelay 사용을 위해서 RxCocoa를 import 해주어야 합니다.
  private var tasks = BehaviorRelay<[Task]>(value: [])
  private var filteredTasks = [Task]()
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
      // 45. 선택한 필터 설정에 맞게 데이터 처리하기.
      // taskSubject 이벤트를 구독하여 taskSubject 이벤트가 발생할때 Task 모델 이벤트를 받아 처리할 수 있다.
      let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
      var existingTasks = self.tasks.value
      existingTasks.append(task)
      self.tasks.accept(existingTasks)
      self.filterTasks(by: priority)
      // or
      // self.tasks.accept(self.tasks.value + [task])
    }).disposed(by: disposeBag)
  }
  
  private func filterTasks(by priority: Priority?) {
    // priority가 nil인 경우는 all이 선택된 경우이므로 별도 필터작업이 필요없이 모든 데이터를 뿌려주면 된다.
    if priority == nil {
      self.filteredTasks = self.tasks.value
    } else {
      self.tasks.map { tasks in
        // 1) tasks 이벤트가 방출되면, 현재 설정한 필터값에 맞는 task만 필터링 하여
        return tasks.filter { $0.priority == priority! }
      }.subscribe(onNext: { [weak self] tasks in
        // 2) filteredTasks에 필터링한 tasks 값을 저장한다.
        self?.filteredTasks = tasks
        print(tasks)
      }).disposed(by: disposeBag)
    }
  }
  
  @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
    // 선택한 segmentedControl inidex에 맞게 priority에 맞는 filteredTasks를 처리한다.
    let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
    filterTasks(by: priority)
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
