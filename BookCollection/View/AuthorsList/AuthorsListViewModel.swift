import Foundation
import DependencyInjection
import DataManagment

class AuthorsListViewModel: ObservableObject {
    private var dataManagment: DataManagment
    
    @Published var hasError = false
    @Published var error: Errors?
    
    init(dataManagement: DataManagment = DependencyInjection.shared.resolveRequired(DataManagment.self)) {
        self.dataManagment = dataManagement
    }
    
    @discardableResult
    func add(_ name: String) async -> Bool {
        if name.checkForSpecialSymbols() {
            return false
        }
        
        let parameters = [#keyPath(Author.name): name]
        do {
            try await dataManagment.addItem(Author.self, parameters: parameters)
            return true
        } catch {
            self.hasError.toggle()
            self.error = .addItem(error)
            return false
        }
    }
    
    @MainActor
    func delete(author: Author) {
        do {
            try dataManagment.delete(object: author)
        } catch {
            self.hasError.toggle()
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
                return NSLocalizedString("Ok", comment: "Ok")
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
