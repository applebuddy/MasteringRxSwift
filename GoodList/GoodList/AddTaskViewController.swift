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

  @IBAction func save() {
    guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
          let title = self.taskTitleTextField.text else {
            return
          }
    
    // delegate 패턴을 통해 값을 전달할 수도 있지만, RxSwift를 활용해서 값을 전달해보자.
    let task = Task(title: title, priority: priority)
    
  }
}
