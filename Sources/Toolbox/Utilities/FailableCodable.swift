//
//  FailableCodable.swift
//  
//
//  Created by Oliver Krakora on 06.11.20.
//

import Foundation

/// A helper that allows you to wrap potential faulty `Codable` data structures
///
/// **Usage**
///
///     struct Person: Codable {
///         let name: String
///         let websiteURL: FailableCodable<URL>
///     }
///
/// The `websiteURL` is defined by a user so there is no guarantee that it is a valid `URL`.
///
///
/// Without `FailableCodable` the decoding would fail for the entire `Person` and you would have to implement the decoding intializer yourself.
///
public enum FailableCodable<T: Codable>: Codable {
    /// Indicates that decoding of the underlying data was successfull
    case success(T)
    /// Indicates that the underlying data failed to decode
    case failure(Error)
    
    /// If the decoding was successfull a non nil value of type `T`
    public var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        do {
            self = try .success(decoder.singleValueContainer().decode(T.self))
        } catch {
            self = .failure(error)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .success(let value):
            try container.encode(value)
        case .failure:
            try container.encodeNil()
        }
    }
}
