//
//  DetailViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Mac on 18.01.2022.
//

import XCTest
@testable import ToDoApp
import CoreLocation

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
        XCTAssert(sut.titleLabel.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionLabel() {
        
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssert(sut.descriptionLabel.isDescendant(of: sut.view))
    }
    
    func testHasDateLabel() {
        
        XCTAssertNotNil(sut.dateLabel)
        XCTAssert(sut.dateLabel.isDescendant(of: sut.view))
    }
    
    func testHasLocationLabel() {
        
        XCTAssertNotNil(sut.locationLabel)
        XCTAssert(sut.locationLabel.isDescendant(of: sut.view))
    }
    
    func testHasMapView() {
        
        XCTAssertNotNil(sut.mapView)
        XCTAssert(sut.mapView.isDescendant(of: sut.view))
    }
    
    func setupTaskAndApperanceTransition() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.4792046, longitude: 37.3273304)
        let location = Location(name: "Baz", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1642486702)
        let task = Task(title: "Foo", description: "Bar",date: date, location: location)
        sut.task = task
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    func testSettingTaskSetsTitleLabel() {
        setupTaskAndApperanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, "Foo")
    }
    
    func testSettingTaskSetsDescriptionLabel() {
        setupTaskAndApperanceTransition()
        
        XCTAssertEqual(sut.descriptionLabel.text, "Bar")
    }
    
    func testSettingTaskSetsLocationLabel() {
        setupTaskAndApperanceTransition()
        
        XCTAssertEqual(sut.locationLabel.text, "Baz")
    }
    
    func testSettingTaskSetsDateLabel() {
        setupTaskAndApperanceTransition()
        
        XCTAssertEqual(sut.dateLabel.text, "18.01.22")
    }
    
    func testSettingTaskSetsMapView() {
        setupTaskAndApperanceTransition()
        
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 55.4792046, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, 37.3273304, accuracy: 0.001)
    }
}
