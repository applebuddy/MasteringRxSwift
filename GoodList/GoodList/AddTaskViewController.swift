//
//  AddTaskViewController.swift
//  GoodList
//
//  Created by MinKyeongTae on 2022/09/19.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
  @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
  @IBOutlet weak var taskTitleTextField: UITextField!
  
  // Task Model 데이터를 저장, 전달하기 위해서 Subject를 사용합니다.
  private let taskSubject = PublishSubject<Task>()
  var taskSubjectObservable: Observable<Task> {
    return taskSubject.asObservable()
  }

  @IBAction func save() {
    guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
          let title = self.taskTitleTextField.text else {
            return
          }
    
    // delegate 패턴을 통해 값을 전달할 수도 있지만, RxSwift를 활용해서 값을 전달해보자.
    let task = Task(title: title, priority: priority)
    // taskSubject를 구독한 곳에서는 특정 task 모델 데이터를 받게 된다.
    taskSubject.onNext(task)
    self.dismiss(animated: true)
  }
}
