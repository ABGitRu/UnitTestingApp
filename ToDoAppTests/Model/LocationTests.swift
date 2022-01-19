//
//  LocationTests.swift
//  ToDoAppTests
//
//  Created by Mac on 17.01.2022.
//

import XCTest
import CoreLocation
@testable import ToDoApp

class LocationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitSetsCoordinates() {
        let coordinate = CLLocationCoordinate2D(
            latitude: 1,
            longitude: 2)
        
        let location = Location(name: "Foo",
                                coordinate: coordinate)
        
        XCTAssertEqual(location.coordinate?.latitude,
                       coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude,
                       coordinate.longitude)
    }
    
    func testInitSetsName() {
        let location = Location(name: "Foo")
        
        XCTAssertEqual(location.name, "Foo")
    }
    
    func testCanBeCreatedFromPlistDictionary() {
        let coordinate = CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0)
        let location = Location(name: "Foo", coordinate: coordinate)
        let dict: [String: Any] = ["name": "Foo",
                                   "latitude": 10.0,
                                   "longitude": 10.0]
        let createdLocation = Location(dict: dict)
        
        XCTAssertEqual(location, createdLocation)
    }
    
    func testCanBeSerializedIntoDictionary() {
        let location = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0))
        let generatedLocation = Location(dict: location.dict)
        
        XCTAssertEqual(location, generatedLocation)
    }


}
