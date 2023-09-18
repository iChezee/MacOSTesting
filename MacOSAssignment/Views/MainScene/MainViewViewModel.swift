import Foundation
import CoreData

class MainViewViewModel: ObservableObject {
    let coreDataManager: any CoreDataManager
    
    init(coreDataManager: any CoreDataManager = CoreDataManagerImplementation.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func addBook(title: String, authorName: String, genreTitle: String, completion: (() -> Void)? = nil) {
        Task {
            do {
                if case .success = await coreDataManager.getBookBy(title: title) {
                    return
                }
                
                let author = try await getAuthor(authorName)
                let genre = try await getGenre(genreTitle)
                
                let entityName = BookMO.entityName
                let parameters = [
                    #selector(getter: BookMO.title).description: title,
                    #selector(getter: BookMO.author).description: author,
                    #selector(getter: BookMO.genre).description: genre
                ] as [String: Any]
                let book = try await coreDataManager.addItem(type: BookMO.self, name: entityName, parameters: parameters).get()
                try await coreDataManager.makeRelations(book: book.objectID, author: author.objectID, genre: genre.objectID)
                completion?()
            } catch {
                print(error)
            }
        }
    }
    
    func remove(_ genre: GenreMO) {
        do {
            try coreDataManager.delete(genre)
        } catch {
            print(error)
        }
    }
}

private extension MainViewViewModel {
    // Fetch author if it was created already
    func getAuthor(_ name: String) async throws -> AuthorMO {
        let fetchedAuthorResult = await coreDataManager.getAuthorBy(name: name)
        switch fetchedAuthorResult {
        case .success(let fetchedAuthor):
            return fetchedAuthor
        case .failure(let error):
            if error as? FetchError == FetchError.nothingIsHere {
                return try await createAuthor(name)
            } else {
                print(error)
                throw(error)
            }
        }
    }
    
    func createAuthor(_ name: String) async throws -> AuthorMO {
        let entityName = AuthorMO.entityName
        let nameField = #selector(getter: AuthorMO.name).description
        return try await coreDataManager.addItem(type: AuthorMO.self, name: entityName, parameters: [nameField: name]).get()
    }
    
    // Fetch genre if it was created already
    func getGenre(_ title: String) async throws -> GenreMO {
        let fetchedResult = await coreDataManager.getGenreBy(title: title)
        switch fetchedResult {
        case .success(let genre):
            return genre
        case .failure(let error):
            if error as? FetchError == FetchError.nothingIsHere {
                return try await createGenre(title)
            } else {
                print(error)
                throw(error)
            }
        }
    }
    
    func createGenre(_ title: String) async throws -> GenreMO {
        let entityName = GenreMO.entityName
        let titleField = #selector(getter: GenreMO.title).description
        return try await coreDataManager.addItem(type: GenreMO.self, name: entityName, parameters: [titleField: title]).get()
    }
}
