//
//  APIClientTests.swift
//  ToDoAppTests
//
//  Created by Mac on 18.01.2022.
//

import XCTest
@testable import ToDoApp

class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!

    override func setUp() {
        super.setUp()
        sut = APIClient()
        mockURLSession = MockURLSession(data: nil, urlResponce: nil, responceError: nil)
        sut.urlSession = mockURLSession
    }

    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func userLogin() {
        let completionHandler = {(token: String?, error: Error?) in }
        sut.login(withName: "name", password: "%qwerty", completionHandler: completionHandler)
    }
    
    func testLoginUsesCorrectHost() {
        userLogin()
        
        XCTAssertEqual(mockURLSession.urlComponents?.host, "todoapp.com")
    }
    
    func testLoginUsesCorrectEndPoint() {
        userLogin()
        
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    func testLoginUsesExptectedQueryParameters() {
        userLogin()
        
        guard let queryItems = mockURLSession.urlComponents?.queryItems else {
            XCTFail()
            return
        }
        
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")
        
        XCTAssert(queryItems.contains(urlQueryItemName))
        XCTAssert(queryItems.contains(urlQueryItemPassword))
    }
    // token -> Data -> completionHandler -> DataTask -> urlSession
    func testSuccessfulLoginCreatesToken() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponce: nil, responceError: nil)
        sut.urlSession = mockURLSession
        let tokenExpectation = expectation(description: "Token Expectation")
        var caughtToken: String?
        sut.login(withName: "login", password: "password") { token, _ in
            caughtToken = token
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(caughtToken, "tokenString")
        }
        
    }
    
    func testLoginInvalidJSONReturnsError() {
        mockURLSession = MockURLSession(data: Data(), urlResponce: nil, responceError: nil)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error Expectation")
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { token, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
        func testLoginWhenDataIsNilReturnError() {
            mockURLSession = MockURLSession(data: nil, urlResponce: nil, responceError: nil)
            sut.urlSession = mockURLSession
            let errorExpectation = expectation(description: "Error Expectation")
            var caughtError: Error?
            sut.login(withName: "login", password: "password") { token, error in
                caughtError = error
                errorExpectation.fulfill()
            }
            waitForExpectations(timeout: 1) { _ in
                XCTAssertNotNil(caughtError)
            }
    }
    
    func testLoginResponseErrorReturnsError() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let error = NSError(domain: "Server error", code: 404, userInfo: nil)
        mockURLSession = MockURLSession(data: jsonDataStub, urlResponce: nil, responceError: error)
        sut.urlSession = mockURLSession
        let errorExpectation = expectation(description: "Error Expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
}

}
extension APIClientTests {
    class MockURLSession: URLSessionProtocol {
        
        var url: URL?
        
        private let mockDataTask: MockURLSessionDataTask
        
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        init(data: Data?, urlResponce: URLResponse?, responceError: Error?) {
            mockDataTask = MockURLSessionDataTask(data: data, urlResponce: urlResponce, responceError: responceError)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
//            return URLSession.shared.dataTask(with: url)
            mockDataTask.completionHandler = completionHandler
            return mockDataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        private let data: Data?
        private let urlResponce: URLResponse?
        private let responceError: Error?
        
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponce: URLResponse?, responceError: Error?) {
            self.data = data
            self.urlResponce = urlResponce
            self.responceError = responceError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponce, self.responceError)
            }
        }
        
    }
}
