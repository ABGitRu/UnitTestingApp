//
//  NewTaskViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Mac on 18.01.2022.
//

import XCTest
@testable import ToDoApp
import CoreLocation

class NewTaskViewControllerTests: XCTestCase {
    
    var sut: NewTaskViewController!
    var placemark: MockCLPlacemark!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        
        super.tearDown()
    }
    
    func testHasTitleTextField() {
        XCTAssert(sut.titleTextField.isDescendant(of: sut.view))
    }
    
    func testHasLocationTextField() {
        XCTAssert(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    func testHasAdressTextField() {
        XCTAssert(sut.adressTextField.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionTextField() {
        XCTAssert(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    func testHasDateTextField() {
        XCTAssert(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func testHasSaveButton() {
        XCTAssert(sut.saveButton.isDescendant(of: sut.view))
    }
    
    func testHasCancelButton() {
        XCTAssert(sut.cancelButton.isDescendant(of: sut.view))
    }
    
    func testSaveUsesGeocoderToConvertCoordinateFromAdress() {
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = df.date(from: "18.01.22")
        sut.titleTextField.text = "Foo"
        sut.locationTextField.text = "Bar"
        sut.dateTextField.text = "18.01.22"
        sut.adressTextField.text = "Москва"
        sut.descriptionTextField.text = "Baz"
        sut.taskManager = TaskManager()
        let mockGeocoder = MockCLGeocoder()
        sut.geocoder = mockGeocoder
        sut.save()
        
        
        let coordinate = CLLocationCoordinate2D(latitude: 55.7615902, longitude: 37.60946)
        let location = Location(name: "Bar", coordinate: coordinate)
        let generatedTask = Task(title: "Foo", description: "Baz", date: date, location: location)
        
        placemark = MockCLPlacemark()
        placemark.mockCoordinate = coordinate
        
        mockGeocoder.completionHandler?([placemark], nil)
        
        let task = sut.taskManager.task(at: 0)
        
        XCTAssertEqual(task, generatedTask)
        
    }
    
    func testSaveButtonHasSaveMethod() {
        let saveButton = sut.saveButton
        
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else { XCTFail()
            return
        }
        
        XCTAssert(actions.contains("save"))
    }
    
    func testGeocoderFetchesCorrectCoordinate() {
        let geocoderAnswer = expectation(description: "Geocoder answer")
        let adressString = "Москва"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adressString) { placemarks, error in
            let placemark = placemarks?.first
            let location = placemark?.location
            
            
            guard let latitude = location?.coordinate.latitude,
                  let longitude = location?.coordinate.longitude else { XCTFail()
                      return }
            
            XCTAssertEqual(latitude, 55.7615902)
            XCTAssertEqual(longitude, 37.60946)
            geocoderAnswer.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSaveDissmissesNewTaskViewController() {
        let mockNewTaskViewController = MockNewTaskViewController()
        mockNewTaskViewController.titleTextField = UITextField()
        mockNewTaskViewController.titleTextField.text = "Foo"
        mockNewTaskViewController.descriptionTextField = UITextField()
        mockNewTaskViewController.descriptionTextField.text = "Bar"
        mockNewTaskViewController.locationTextField = UITextField()
        mockNewTaskViewController.locationTextField.text = "Baz"
        mockNewTaskViewController.adressTextField = UITextField()
        mockNewTaskViewController.adressTextField.text = "Москва"
        mockNewTaskViewController.dateTextField = UITextField()
        mockNewTaskViewController.dateTextField.text = "01.01.01"
        
        mockNewTaskViewController.save()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertTrue(mockNewTaskViewController.isDissmissed)
        }
    }
    
    


}

extension NewTaskViewControllerTests {
    class MockCLGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockCLPlacemark: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D!
        
       override var location: CLLocation? {
           return CLLocation(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude)
        }
    }
}
extension NewTaskViewControllerTests {
    class MockNewTaskViewController: NewTaskViewController {
        var isDissmissed = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            isDissmissed = true
        }
    }
}
