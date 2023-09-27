import Foundation
import DependencyInjection
import DataManagment

class AuthorsListViewModel: ObservableObject {
    @Injected private var dataManagment: DataManagment
    
    @Published var hasError = false
    @Published var error: Errors?
    
    func add(_ name: String) async {
        let parameters = ["name": name]
        do {
            try await dataManagment.addItem(Author.self, parameters: parameters)
        } catch {
            self.error = .addItem(error)
        }
    }
    
    @MainActor
    func delete(author: Author) {
        do {
            try dataManagment.delete(object: author)
        } catch {
            self.error = .deleteItem(error)
        }
    }
}

extension AuthorsListViewModel {
    enum Errors: LocalizedError {
        case addItem(Error)
        case deleteItem(Error)
        
        public var errorDescription: String? {
            switch self {
            case .addItem(let error):
                return error.localizedDescription
            case .deleteItem(let error):
                return error.localizedDescription
            }
        }
        
        public var failureReason: String? {
            switch self {
            case .addItem(let error):
                return error.localizedDescription
            case .deleteItem(let error):
                return error.localizedDescription
            }
        }
        
        public var recoverySuggestion: String? {
            switch self {
            default:
                return NSLocalizedString("ok.button", comment: "Ok")
            }
        }
        
        public var helpAnchor: String? {
            switch self {
            case .addItem(let error):
                return error.localizedDescription
            case .deleteItem(let error):
                return error.localizedDescription
            }
        }
    }
}
