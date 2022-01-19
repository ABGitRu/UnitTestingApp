//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Mac on 19.01.2022.
//

import XCTest
@testable import ToDoApp

class ToDoAppTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        
        super.tearDown()
    }
    
    func testInitialViewControllerIsTaskListViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
        let rootViewControoler = navigationController.viewControllers.first as! TaskListViewController
        
        XCTAssert(rootViewControoler is TaskListViewController)
    }
}
