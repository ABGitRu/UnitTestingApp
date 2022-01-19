//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by Mac on 17.01.2022.
//

import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: DataProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        let taskManager = TaskManager()
        dataProvider.taskManager = taskManager
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showDetail(withNotification:)),
                                               name: NSNotification.Name(rawValue: "DidSelectRow"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func showDetail(withNotification notification: Notification) {
            guard
                let userInfo = notification.userInfo,
                let task = userInfo["task"] as? Task else { fatalError() }
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else {
            return
        }
        detailVC.task = task
        navigationController?.pushViewController(detailVC, animated: true)
        }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController {
            viewController.taskManager = self.dataProvider.taskManager
            present(viewController, animated: true, completion: nil)
        }
        
    }
}

