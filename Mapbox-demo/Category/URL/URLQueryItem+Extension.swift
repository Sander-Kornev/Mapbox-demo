//
//  URLQueryItem+Extension.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation

extension URLQueryItem: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        self.init(name: (elements.first?.0).orEmpty, value: elements.first?.1)
    }
}

extension URLQueryItem {
    public init(tuple element: (String, String)) {
        self.init(name: element.0, value: element.1)
    }
}

extension Array: ExpressibleByDictionaryLiteral where Element == URLQueryItem {
    public init(dictionaryLiteral elements: (String, String?)...) {
        self = elements.map(URLQueryItem.init)
    }
}

extension Dictionary where Key == String, Value == String {
    var queryItems: [URLQueryItem] {
        map(URLQueryItem.init(tuple:))
    }
}
