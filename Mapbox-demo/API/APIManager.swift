//
//  APIManager.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation
import Combine

class APIManager {
    
    private var baseUrl: URL {
        let url = URL(string: "https://midgard.netzmap.com")!
        return url
    }

    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    func performRequest<Obj>(_ request: APIDecodableRequest<Obj>) -> AnyPublisher<Obj, String> {
    
        let urlRequest = networkRequest(for: request)
        
        return Just<Void>(())
            .setFailureType(to: String.self)
            .flatMap { _ -> AnyPublisher<(data: Data, response: URLResponse), String> in
                // print start of the request
                
                return URLSession.shared.dataTaskPublisher(for: urlRequest)
                    .mapError { error in
                        return error.localizedDescription
                    }
                    .eraseToAnyPublisher()
            }
            .tryMap { apiResponse -> URLSession.DataTaskPublisher.Output in
                
                guard let response = apiResponse.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw "Wrong response code"
                }
                return apiResponse
            }
            .mapError {
                return $0 as! String
            }
            .flatMap { apiResponse -> AnyPublisher<Obj, String> in
                Just(apiResponse.data)
                    .decode(type: Obj.self, decoder: request.decoder)
                    .mapError { _ in
                        return "Wrong result type"
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func networkRequest<Obj>(for request: APIDecodableRequest<Obj>) -> URLRequest {

        var url = baseUrl
        url = url.appendingPathComponent(request.urlAdditionalPath)
        
        var urlComps = URLComponents(url: url,
                                     resolvingAgainstBaseURL: true)!
        if let queryItems = request.getParameters?.queryItems {
            urlComps.queryItems = queryItems
        }
        
        // make url encoded get query
        let finalUrl = urlComps.url!
        var urlRequest = Foundation.URLRequest(url: finalUrl)
        
        if [.POST, .PUT, .DELETE, .PATCH].contains(request.httpMethod) {
            
            switch request.encoding {
            case .url:
                let postValue = request
                    .postParameters
                    .orEmpty
                    .flatMap { queryComponents(fromKey: $0, value: $1) }
                    .map { [$0.0, $0.1] }
                    .map { $0.joined(separator: "=") }
                    .map { [$0] }
                    .reduce([String](), + )
                    .joined(separator: "&")
                    .data(using: .utf8)
                
                urlRequest.httpBody = postValue
                
                urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
            case .json:
                if let data = try? JSONSerialization.data(withJSONObject: request.postParameters.orEmpty, options: [.prettyPrinted]), let jsonString = String(data: data, encoding: .utf8), let body = jsonString.data(using: .utf8) {
                        urlRequest.httpBody = body
                } else {
                    assertionFailure("Can't generate json string")
                }
                
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
            }
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = request.httpMethod.rawValue

        return urlRequest
    }
    
    //Method from Alamofire 4.4.0 - struct URLEncoding / removed escape()
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((key, value.boolValue ? "1" : "0"))
            } else {
                components.append((key, "\(value)"))
            }
        } else if let bool = value as? Bool {
            components.append((key, bool ? "1" : "0"))
        } else {
            components.append((key, "\(value)"))
        }
        
        return components
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

extension String: Error {}
