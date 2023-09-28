import Foundation

enum DIResolverError: CustomStringConvertible, Error {
    case unregisteredDependency(String)
    
    var description: String {
        switch self {
        case .unregisteredDependency(let name):
            return "attempting to resolve unregistered dependency \(name)"
        }
    }
}

public protocol DIResolver {
    func resolve<Service>(_ serviceType: Service.Type) throws -> Service
    func resolveRequired<Service>(_ serviceType: Service.Type) -> Service
}

extension DIResolver {
    public func resolveRequired<Service>(_ serviceType: Service.Type) -> Service {
        var result: Service! // swiftlint:disable:this implicitly_unwrapped_optional
        do {
            result = try resolve(serviceType)
        } catch {
            assertionFailure("DIResolver:resolveRequired \(error)")
        }
        return result
    }
}
