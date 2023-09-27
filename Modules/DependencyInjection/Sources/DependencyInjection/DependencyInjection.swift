import Swinject

public final class DependencyInjection: DIContainer {
    private init() {}
    
    public static let shared = DependencyInjection()
    let container = Container()
    
    /// remove all registered instances
    public func removeAll() {
        container.removeAll()
    }
    
    public func register<Service>(_ serviceType: Service.Type,
                                  instanceType: InstanceType,
                                  factory: @escaping (DIResolver) -> Service) {
        
        container.register(serviceType) { resolver in
            return factory(SwinjectResolver(resolver))
        }
        .inObjectScope(instanceType.objectScope)
    }
}

extension DependencyInjection: DIResolver {
    public func resolve<Service>(_ serviceType: Service.Type) throws -> Service {
        guard let service = container.synchronize().resolve(serviceType) else {
            let error = DIResolverError.unregisteredDependency(String(describing: serviceType))
            throw error
        }
        return service
    }
}

extension InstanceType {
    var objectScope: ObjectScope {
        switch self {
        case .newInstance:
            return ObjectScope.graph
        case .sharedInstance:
            return ObjectScope.container
        }
    }
}

