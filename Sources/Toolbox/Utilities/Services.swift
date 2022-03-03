
import Foundation

/// A propertyWrapper that is used to retrieve a dependency of specific type
///
/// Usage:
///
/// `@ServiceSingleton var fancyDependency: FancyDependencyProtocol`
@propertyWrapper public struct ServiceSingleton<Type> {
    
    private let services: Services
    
    public var wrappedValue: Type {
        services[Type.self]
    }
    
    public init(services: Services = Services.shared) {
        self.services = services
    }
}

/// A lightweight IoC container for dependency injection
///
/// Usage:
///
/// Registering a dependency:
///
/// `Services.shared.register(service: YourImplementationOfProtocol, superType: Protocol)`
///
/// Retrieving a dependency:
///
/// `Services.shared[Protocol.self]`
///
/// You can define own instances of  IoC containers by just calling `Services()` and assigning it to property that holds a strong reference to the container
public class Services {
        
    public static let shared = Services()
    
    private var registeredServices = [String: Any]()
            
    public init() {}
    
    private func identifier<Type>(for type: Type.Type) -> String {
        String(reflecting: type)
    }
    
    // MARK: Register services
    
    public func register<Type>(service: Type) {
        register(service: service, superType: Type.self)
    }
    
    public func register<Type, SuperType>(service: Type, superType: SuperType.Type) {
        guard service is SuperType else {
            fatalError("\(SuperType.self) is no ancestor of \(Type.self)")
        }
        let identifier = self.identifier(for: SuperType.self)
        guard registeredServices[identifier] == nil else {
            fatalError("Service \(identifier) is already registered")
        }
        registeredServices[identifier] = service
    }
        
    // MARK: Unregister services
    
    public func unregister<Type>(service: Type.Type) {
        let idenfifier = self.identifier(for: service)
        registeredServices.removeValue(forKey: idenfifier)
    }
    
    // MARK: Replace registered services
    
    public func replace<Type>(with newService: Type) {
        replace(of: Type.self, newService: newService)
    }
    
    public func replace<Type, SuperType>(of superType: SuperType.Type, newService: Type) {
        let identifier = self.identifier(for: SuperType.self)
        guard registeredServices[identifier] != nil else {
            fatalError("No service of type: \(SuperType.self) found")
        }
        registeredServices[identifier] = newService
    }
    
    // MARK: Request services
    
    public func request<Type>(_ type: Type.Type = Type.self) -> Type {
        let identifier = self.identifier(for: type)
        guard let service = registeredServices[identifier] as? Type else {
            fatalError("No service of type: \(type) found")
        }
        return service
    }
    
    public func requestIfExists<Type>(_ type: Type.Type = Type.self) -> Type? {
        let identifier = self.identifier(for: type)
        return registeredServices[identifier] as? Type
    }
    
    public subscript<Type>(type: Type.Type) -> Type {
        get {
            return request(type)
        } set {
            register(service: newValue)
        }
    }
}
