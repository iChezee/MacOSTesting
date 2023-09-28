@propertyWrapper
public struct Injected<Service> {
    public init() {}
    
    public var wrappedValue: Service {
        let dependencyInjection = DependencyInjection.shared
        return dependencyInjection.resolveRequired(Service.self)
    }
}
