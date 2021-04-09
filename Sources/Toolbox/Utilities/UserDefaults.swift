import Foundation
// https://swiftbysundell.com/articles/property-wrappers-in-swift/
// Since our property wrapper's Value type isn't optional, but
// can still contain nil values, we'll have to introduce this
// protocol to enable us to cast any assigned value into a type
// that we can compare against nil:
private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

@propertyWrapper public struct UserDefault<Value> {
    public let key: String
    public let defaultValue: Value
    public var storage: UserDefaults = .standard
    
    public var wrappedValue: Value {
        set {
            if let anyOptional = newValue as? AnyOptional, anyOptional.isNil {
                storage.removeObject(forKey: key)
            } else {
                storage.set(newValue, forKey: key)
            }
        } get {
            return getValue()
        }
    }
    
    public init(key: String, defaultValue: Value, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

public extension UserDefault where Value: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}

private extension UserDefault {
    /// UserDefaults coerces certain types, in order to keep that behaviour, the data retrieval has to be performed with the typed functions
    private func getValue() -> Value {
        
        let type = nestedType(of: Value.self)
        
        let value: Value?
    
        if type == Bool.self {
            value = storage.bool(forKey: key) as? Value
        } else if type == Int.self {
            value = storage.integer(forKey: key) as? Value
        } else if type == Float.self {
            value = storage.float(forKey: key) as? Value
        } else if type == Double.self {
            value = storage.double(forKey: key) as? Value
        } else if type == URL.self {
            value = storage.url(forKey: key) as? Value
        } else {
            value = storage.value(forKey: key) as? Value
        }
        
        return value ?? defaultValue
    }
}
