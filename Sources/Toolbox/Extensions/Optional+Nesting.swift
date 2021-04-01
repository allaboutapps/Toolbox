import Foundation

/// Inspired by https://stackoverflow.com/a/32780793/5240391
/// marker protocol should not be used by anyone else
private protocol OptionalProtocol {
    
    static func _nestedType() -> Any.Type
    
    func _flattenedValue<T>(type: T.Type) -> T?
}

extension Optional {
    /// - Returns: The `Wrapped` type of the Optional
    static func wrappedType() -> Any.Type {
        return Wrapped.self
    }
}

extension Optional: OptionalProtocol {
    
    static func _nestedType() -> Any.Type {
        guard let type = wrappedType() as? OptionalProtocol.Type else { return wrappedType() }
        return type._nestedType()
    }
    
    func _flattenedValue<T>(type: T.Type) -> T? {
        guard case let .some(val) = self else { return nil }
        
        if let val = val as? OptionalProtocol {
            return val._flattenedValue(type: type)
        } else {
            return val as? T
        }
    }
}

public extension Optional {
    
    /// Recursively retrieves the `Type` of Wrapped
    ///
    /// `Optional<Optional<Double>> `will result in `Double`
    static func nestedType() -> Any.Type {
        return _nestedType()
    }
    
    /// - Parameter type: The type of the nested value
    /// - Returns: The nested value of Self e.g. `Optional(Optional(2))` will return `Optional(2)`
    func flattenedValue<T>(type: T.Type = T.self) -> T? {
        return _flattenedValue(type: type)
    }
}

/// - Returns: The type that is wrapped inside the given type
/// - Note: This is a convenience function and will only return a different type than type when type is an `Optional`
public func nestedType(of type: Any.Type) -> Any.Type {
    guard let optionalType = type as? OptionalProtocol.Type else { return type }
    return optionalType._nestedType()
}

/// See Optional.flattenedValue
public func flattenedValue(of value: Any) -> Any? {
    guard let optionalValue = value as? OptionalProtocol else { return value }
    return optionalValue._flattenedValue(type: Any.self)
}
