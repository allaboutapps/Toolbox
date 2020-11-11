//
//  SemanticVersion.swift
//  
//
//  Created by Oliver Krakora on 11.11.20.
//

import Foundation

/// Semantic versioning implemented according to [semver.org](https://semver.org/spec/v2.0.0.html)
///
/// - Note: pre-release versions and build identifiers are not supported
public struct SemanticVersion {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public init(major: Int, minor: Int, patch: Int = 0) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}

// MARK: Codable

extension SemanticVersion: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let versionString = try container.decode(String.self)
        guard let version = SemanticVersion(versionString) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Version string: \(versionString) is invalid"))
        }
        self = version
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

// MARK: Comparable

extension SemanticVersion: Comparable {
    
    public static func == (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
    
    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        } else if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        } else {
            return lhs.patch < rhs.patch
        }
    }
}

// MARK: - LosslessStringConvertible

extension SemanticVersion: LosslessStringConvertible {
    public var description: String { "\(major).\(minor).\(patch)" }
    
    public init?(_ string: String) {
        let splitted = string.split(separator: ".")
        guard splitted.count >= 2 && splitted.count <= 3 else { return nil }
        guard let majorString = splitted[safeIndex: 0], let minorString = splitted[safeIndex: 1] else { return nil }
        guard let major = Int(majorString), let minor = Int(minorString) else { return nil }
        
        self.major = major
        self.minor = minor
        
        if let patchString = splitted[safeIndex: 2] {
            if let patch = Int(patchString) {
                self.patch = patch
            } else {
                return nil
            }
        } else {
            self.patch = 0
        }
    }
}

// MARK: ExpressibleByStringLiteral

extension SemanticVersion: ExpressibleByStringLiteral {

    public init(stringLiteral: StaticString) {
        self = SemanticVersion("\(stringLiteral)")!
    }
}
