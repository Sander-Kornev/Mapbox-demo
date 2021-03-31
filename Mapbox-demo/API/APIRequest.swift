//
//  APIRequest.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation
import Combine

class APIDecodableRequest<T: Decodable> {
    
    var decoder: JSONDecoder {
        let decooder = JSONDecoder()
        decooder.keyDecodingStrategy = .convertFromSnakeCase
        return decooder
    }
    
    enum TypeName: String {
        case POST, GET, PUT, DELETE, PATCH
    }
    
    enum Encoding {
        case url, json
    }
    
    var postParameters: [String: Any]?
    var getParameters: [String: String]?
    var urlAdditionalPath = ""
    
    var httpMethod: TypeName
    var encoding = Encoding.url
    
    internal init(with method: TypeName) {
        self.httpMethod = method
    }
    
    static func GET<T: Decodable>() -> APIDecodableRequest<T> {
        return APIDecodableRequest<T>(with: .GET)
    }
    
    static func POST<T: Decodable>() -> APIDecodableRequest<T> {
        return APIDecodableRequest<T>(with: .POST)
    }
    
    static func PUT<T: Decodable>() -> APIDecodableRequest<T> {
        return APIDecodableRequest<T>(with: .PUT)
    }
    
    static func DELETE<T: Decodable>() -> APIDecodableRequest<T> {
        return APIDecodableRequest<T>(with: .DELETE)
    }
    
    static func PATCH<T: Decodable>() -> APIDecodableRequest<T> {
        return APIDecodableRequest<T>(with: .PATCH)
    }
}
