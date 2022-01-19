//
//  TaskListViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Mac on 17.01.2022.
//

import XCTest
@testable import ToDoApp

class TaskListViewControllerTests: XCTestCase {
    
    var sut: TaskListViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        sut = vc as? TaskListViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testWhenViewisLoadedTableViewNotNil() {
        
        XCTAssertNotNil(sut.tableView)
    }
    
    func testWhenViewIsLoadedDataProviderIsNotNil() {
        
        XCTAssertNotNil(sut.dataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        XCTAssert(sut.tableView.delegate is DataProvider)
    }

    func testWhenViewIsLoadedTableViewDataSourceIsSet() {
        XCTAssert(sut.tableView.dataSource is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateEqualsTableViewDataSource() {
        XCTAssertEqual(sut.tableView.delegate as? DataProvider,
                       sut.tableView.dataSource as? DataProvider)
    }
    
    func testTaskListVCHasAddBarButtonWithSelfIsTarger() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    func presentingNewTaskViewController() -> NewTaskViewController {
        guard
            let newTaskButton = sut.navigationItem.rightBarButtonItem,
            let action = newTaskButton.action else {
                return NewTaskViewController()
            }
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        return newTaskViewController
    }
    
    func testAddNewTaskPresentsNewTaskViewController() {
        let newTaskViewController = presentingNewTaskViewController()
        XCTAssertNotNil(newTaskViewController.titleTextField)
    }
    
    func testSharesSameTaskManagerWithNewTaskVC() {
        let newTaskViewController = presentingNewTaskViewController()
        XCTAssertNotNil(sut.dataProvider.taskManager)
        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager)
    }
    
    func testWhenViewAppearedTableViewReloaded() {
        let mockTableView = MockTableView()
        
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    func testTappingCellSendsNotification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager?.add(task: task)
        
        expectation(forNotification: NSNotification.Name(rawValue: "DidSelectRow"), object: nil) { notification -> Bool in
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else { return false }
            return task == taskFromNotification
        }
        let tableView = sut.tableView
        tableView?.delegate?.tableView?(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSelectedCellNotificationPushesDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        
        sut.loadViewIfNeeded()
        
        let task = Task(title: "Foo")
        let task1 = Task(title: "Bar")
        sut.dataProvider.taskManager?.add(task: task)
        sut.dataProvider.taskManager?.add(task: task1)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidSelectRow"), object: self, userInfo: ["task": task1])
        
        guard let detailVC = mockNavigationController.pushedController as? DetailViewController else {
            XCTFail()
            return
        }
        detailVC.loadViewIfNeeded()
        XCTAssertNotNil(detailVC.titleLabel)
        XCTAssertTrue(detailVC.task == task1)
    }

}
extension TaskListViewControllerTests {
    class MockTableView: UITableView {
        var isReloaded = false
        override func reloadData() {
            isReloaded = true
        }
    }
}

extension TaskListViewControllerTests {
    class MockNavigationController: UINavigationController {
        var pushedController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedController = viewController
            super.pushViewController(viewController, animated: true)
        }
    }
}
