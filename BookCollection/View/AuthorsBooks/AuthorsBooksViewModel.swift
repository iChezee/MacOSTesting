import Foundation
import DependencyInjection
import DataManagment

class AuthorsBooksViewModel: ObservableObject {
    @Published var hasError = false
    @Published var error: Errors?
    private let dataManagment: DataManagment
    
    init(dataManagement: DataManagment = DependencyInjection.shared.resolveRequired(DataManagment.self)) {
        self.dataManagment = dataManagement
    }
    
    func addBook(title: String) async {
        guard let author = SelectedViewState.shared.selectedAuthor else {
            hasError = true
            error = .addBookNoAuthor(nil)
            return
        }
        let parameters = [
            #keyPath(Book.title): title,
            #keyPath(Book.author): author
        ] as [String: Any]
        do {
            try await dataManagment.addItem(Book.self, parameters: parameters)
            await searchForBook(title, by: author.name)
        } catch {
            hasError = true
            self.error = .addBookNoAuthor(error)
        }
    }
    
    func delete(book: Book) {
        do {
            try dataManagment.delete(object: book)
        } catch {
            hasError = true
            self.error = .deleteBook(error)
        }
    }
}

private extension AuthorsBooksViewModel {
    func searchForBook(_ title: String, by author: String?) async {
        // TODO: Search at internet for proposed books
    }
}

extension AuthorsBooksViewModel {
    enum Errors: LocalizedError {
        case addBookNoAuthor(Error?)
        case deleteBook(Error)
        
        public var errorDescription: String? {
            switch self {
            case .addBookNoAuthor(let error):
                return error?.localizedDescription ?? ""
            case .deleteBook(let error):
                return error.localizedDescription
            }
        }
        
        public var failureReason: String? {
            switch self {
            case .addBookNoAuthor(let error):
                return error?.localizedDescription ?? ""
            case .deleteBook(let error):
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
            case .addBookNoAuthor(let error):
                return error?.localizedDescription ?? ""
            case .deleteBook(let error):
                return error.localizedDescription
            }
        }
    }
}
