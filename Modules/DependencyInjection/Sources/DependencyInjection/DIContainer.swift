import Foundation

public enum InstanceType {
    case newInstance
    case sharedInstance
}

public protocol DIContainer {
    func register<Service>(_ serviceType: Service.Type, factory: @escaping (DIResolver) -> Service)
    func register<Service>(_ serviceType: Service.Type, instanceType: InstanceType, factory: @escaping (DIResolver) -> Service)
}

extension DIContainer {
    public func register<Service>(_ serviceType: Service.Type, factory: @escaping (DIResolver) -> Service) {
        self.register(serviceType, instanceType: .sharedInstance, factory: factory)
    }
}
