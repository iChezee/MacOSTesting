import Swinject

import Foundation

class SwinjectResolver {
    let swiftInjectResolver: Swinject.Resolver
    
    init(_ swiftInjectResolver: Swinject.Resolver) {
        self.swiftInjectResolver = swiftInjectResolver
    }
}

extension SwinjectResolver: DIResolver {
    func resolve<Service>(_ serviceType: Service.Type) throws -> Service {
        guard let service = swiftInjectResolver.resolve(serviceType) else {
            let error = DIResolverError.unregisteredDependency(String(describing: serviceType))
            print("SwiftInjectResolver:resolve \(error)")
            throw error
        }
        return service
    }
}
