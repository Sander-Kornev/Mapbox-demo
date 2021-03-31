//
//  Optional+Extension.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation
import UIKit

public protocol _CollectionOrStringish {
    var isEmpty: Bool { get }
    static var emptyValue: Self { get }
}

extension String: _CollectionOrStringish {
    public static var emptyValue: String {
        return ""
    }
}
extension Data: _CollectionOrStringish {
    public static var emptyValue: Data {
        return Data()
    }
    
    public var isEmpty: Bool {
        return count == 0
    }
}

extension Int: _CollectionOrStringish {
    public var isEmpty: Bool {
        return self == 0
    }
    public static var emptyValue: Int {
        return 0
    }
}

extension Array: _CollectionOrStringish {
    
    public typealias ArrayType = Array.Element
    
    public static var emptyValue: [ArrayType] {
        return [ArrayType]()
    }
}
extension Dictionary: _CollectionOrStringish {
    
    public typealias DictionaryKey = Dictionary.Key
    public typealias DictionaryValue = Dictionary.Value
    
    public static var emptyValue: [DictionaryKey: DictionaryValue] {
        return [DictionaryKey: DictionaryValue]()
    }
}
extension Set: _CollectionOrStringish {
    public typealias SetType = Set.Element
    
    public static var emptyValue: Set<SetType> {
        return Set<SetType>()
    }
}

extension Optional where Wrapped: _CollectionOrStringish {
        
    var nonEmpty: Bool {
        switch self {
        case let .some(value): return !value.isEmpty
        default: return false
        }
    }
    
    var nonEmptyValue: Wrapped? {
        switch self {
        case let .some(value): return value.isEmpty ? nil : value
        default: return nil
        }
    }
    
    var orEmpty: Wrapped {
        switch self {
        case let .some(value): return value
        default: return Wrapped.emptyValue
        }
    }
}

extension Optional where Wrapped == NSSet {
    
    var nonEmpty: Bool {
        switch self {
        case let .some(value): return value.count > 0
        default: return false
        }
    }
    
    var nonEmptyValue: Wrapped? {
        switch self {
        case let .some(value): return value.count == 0 ? nil : value
        default: return nil
        }
    }
    
    var orEmpty: Wrapped {
        switch self {
        case let .some(value): return value
        default: return NSSet()
        }
    }
}

extension Optional where Wrapped: StringProtocol {
    var orNilText: String {
        switch self {
        case let .some(value): return String(value)
        default: return "nil"
        }
    }
}

extension Optional where Wrapped == NSNumber {
    var orZero: NSNumber {
        switch self {
        case let .some(value): return value
        default: return 0
        }
    }
}
