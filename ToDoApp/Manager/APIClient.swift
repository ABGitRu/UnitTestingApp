//
//  APIClient.swift
//  ToDoApp
//
//  Created by Mac on 18.01.2022.
//

import Foundation

enum NetworkError: Error {
    case emptyNetwork
}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIClient {
    lazy var urlSession: URLSessionProtocol = URLSession.shared
    
    func login(withName name: String, password: String, completionHandler: @escaping (String?, Error?) -> Void) {
        let nameEncoded = name.percentEncoded
        let passwordEncoded = password.percentEncoded
        let query = "name=\(nameEncoded)&password=\(passwordEncoded)"
        guard let url = URL(string: "https://todoapp.com/login?\(query)") else { fatalError() }
        
        urlSession.dataTask(with: url) { data, responce, error in
            do {
                guard let data = data else {
                    completionHandler(nil, NetworkError.emptyNetwork)
                    return
                }
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                let token = dictionary["token"]
                completionHandler(token, error)
            } catch {
                completionHandler(nil, error)
            }
        }
        .resume()
    }
}

extension String {
    var percentEncoded: String {
        let allowedCharacters = CharacterSet(charactersIn: "±!@#$%^&*)?<>/\\").inverted
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        return encodedString
    }
}
