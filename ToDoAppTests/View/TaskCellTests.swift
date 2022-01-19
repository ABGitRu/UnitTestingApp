//
//  TaskCellTests.swift
//  ToDoAppTests
//
//  Created by Mac on 18.01.2022.
//

import XCTest
@testable import ToDoApp
import CoreLocation

class TaskCellTests: XCTestCase {
    
    var cell: TaskCell!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as! TaskListViewController
        vc.loadViewIfNeeded()
        
        let tableView = vc.tableView
        let dataSource = FakeDataSource()
        tableView?.dataSource = dataSource
        
        cell = tableView?.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: IndexPath(row: 0, section: 0)) as? TaskCell
    }

    override func tearDown() {
        cell = nil
        super.tearDown()
    }

    func testCellHasTitleLabel() {
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func testCellHasTitleLabelInContentView() {
        XCTAssert(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    func testCellHasLocationLabel() {
        XCTAssertNotNil(cell.locationLabel)
    }
    
    func testCellHasLocationLabelInContentView() {
        XCTAssert(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    func testCellHasDateLabel() {
        XCTAssertNotNil(cell.dateLabel)
    }
    
    func testCellHasDateLabelInContentView() {
        XCTAssert(cell.dateLabel.isDescendant(of: cell.contentView))
    }
    
    func testConfigureSetsTitle() {
        let task = Task(title: "Foo")
        
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.titleLabel.text, task.title)
    }
    
    func testConfigureSetsDate() {
        let task = Task(title: "Foo")
        
        cell.configure(withTask: task)
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = task.date
        let dateString = df.string(from: date)
        
        XCTAssertEqual(cell.dateLabel.text, dateString)
    }
    
    func testConfigureSetsLocation() {
        let task = Task(title: "Foo", description: "Bar", location: Location(name: "Baz", coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1)))
        
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.locationLabel.text, task.location?.name)
    }
    
    func testDoneTaskShouldStrikeThrough() {
        configureCellWithTask()
        
        let attributedString = NSAttributedString(string: "Foo", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
    }
    
    func testDoneTaskDateLabelTextEqualsEqualsEmptyString() {
        configureCellWithTask()
        
        XCTAssertEqual(cell.dateLabel.text, "")
    }
    
    func testDoneTasklocationLabelEqualsEmptyString() {
        configureCellWithTask()
        
        XCTAssertEqual(cell.locationLabel.text, "")
    }
    
    func configureCellWithTask() {
        let task = Task(title: "Foo")
        
        cell.configure(withTask: task, done: true)
    }
    
    

}
extension TaskCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
        
        
    }
}
