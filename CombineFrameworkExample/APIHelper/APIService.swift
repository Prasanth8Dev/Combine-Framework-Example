//
//  APIService.swift
//  CombineFrameworkExample
//
//  Created by Prasanth S on 20/08/24.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    
    func fetchDataWithPostMethod<T:Codable>(url: URL, param:[String:Any], model: T.Type, boundary: String = UUID().uuidString) -> AnyPublisher<T,Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(boundary)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Construct HTTPBody
        var body = Data()
        for (key, value) in param {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            if let value = value as? String {
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            } else if let value = value as? Data {
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"file\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
                body.append(value)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        return URLSession.shared.dataTaskPublisher(for: request).map(\.data).decode(type: T.self, decoder: JSONDecoder()).receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    func fetchRawDataWithFormData(url: URL, param: [String: Any], boundary: String = UUID().uuidString) -> AnyPublisher<Data, Error> {
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           
           let boundary = "Boundary-\(boundary)"
           request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
           
           // Construct HTTPBody
           var body = Data()
           for (key, value) in param {
               body.append("--\(boundary)\r\n".data(using: .utf8)!)
               if let value = value as? String {
                   body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                   body.append("\(value)\r\n".data(using: .utf8)!)
               } else if let value = value as? Data {
                   body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"file\"\r\n".data(using: .utf8)!)
                   body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
                   body.append(value)
                   body.append("\r\n".data(using: .utf8)!)
               }
           }
           body.append("--\(boundary)--\r\n".data(using: .utf8)!)
           
           request.httpBody = body
           
           return URLSession.shared.dataTaskPublisher(for: request)
               .map(\.data)
               .mapError { $0 as Error }
               .eraseToAnyPublisher()
       }
}
