import CoreData
import Foundation

class CoreDataManagerImplementation: CoreDataManager {
    static let shared = CoreDataManagerImplementation()

    lazy var mainContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()

    // TODO: Make migrations
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    @discardableResult
    func addItem<Object>(type: Object.Type, name: String, parameters: [String: Any]) async throws -> Result<Object, Error> {
        return try mainContext.performAndWait {
            let entity = NSEntityDescription.insertNewObject(forEntityName: name, into: self.mainContext)
            for key in parameters.keys {
                if let value = parameters[key] as? NSManagedObject {
                    let object = self.mainContext.object(with: value.objectID)
                    entity.setValue(object, forKey: key)
                } else {
                    entity.setValue(parameters[key], forKey: key)
                }
            }
            try self.mainContext.save()
            return .success(entity as! Object) // swiftlint:disable:this force_cast
        }
    }
    
    func makeRelations(book: NSManagedObjectID, author: NSManagedObjectID, genre: NSManagedObjectID) async throws {
        try await backgroundContext.perform {
            guard let book = self.backgroundContext.object(with: book) as? BookMO,
                  let author = self.backgroundContext.object(with: author) as? AuthorMO,
                  let genre = self.backgroundContext.object(with: genre) as? GenreMO else {
                return
            }
            author.addToBooks(book)
            genre.addToBooks(book)
            try self.backgroundContext.save()
        }
    }
    
    func getAuthorBy(name: String) async -> Result<AuthorMO, Error> {
        return await persistentContainer.performBackgroundTask({ context in
            let request = AuthorMO.fetchRequest()
            let nameField = #selector(getter: AuthorMO.name).description
            request.predicate = NSPredicate(format: "\(nameField) == %@", name)
            request.fetchLimit = 1
            
            do {
                if let author = try context.fetch(request).first {
                    return .success(author)
                } else {
                    return .failure(FetchError.nothingIsHere)
                }
            } catch {
                return .failure(error)
            }
        })
    }
    
    func getGenreBy(title: String) async -> Result<GenreMO, Error> {
        return await persistentContainer.performBackgroundTask({ context in
            let request = GenreMO.fetchRequest()
            let nameField = #selector(getter: GenreMO.title).description
            request.predicate = NSPredicate(format: "\(nameField) == %@", title)
            request.fetchLimit = 1
            
            do {
                if let genre = try context.fetch(request).first {
                    return .success(genre)
                } else {
                    return .failure(FetchError.nothingIsHere)
                }
            } catch {
                return .failure(error)
            }
        })
    }
    
    func getBookBy(title: String) async -> Result<BookMO, Error> {
        return await persistentContainer.performBackgroundTask({ context in
            let request = BookMO.fetchRequest()
            let titleField = #selector(getter: BookMO.title).description
            request.predicate = NSPredicate(format: "\(titleField) == %@", title)
            request.fetchLimit = 1
            do {
                if let book = try context.fetch(request).first {
                    return .success(book)
                } else {
                    return .failure(FetchError.nothingIsHere)
                }
            } catch {
                return .failure(error)
            }
        })
    }
    
    func delete(_ genre: GenreMO) throws {
        try mainContext.performAndWait {
            let request = BookMO.fetchRequest()
            request.predicate = NSPredicate(format: "\(#keyPath(BookMO.genre)) == %@", genre)
            let books = try mainContext.fetch(request)
            for book in books {
                try delete(book)
            }
            genre.prepareForDeletion()
            mainContext.delete(genre)
            try mainContext.save()
        }
    }
    
    func delete(_ author: AuthorMO) throws {
        try mainContext.performAndWait {
            let request = BookMO.fetchRequest()
            request.predicate = NSPredicate(format: "\(#keyPath(BookMO.author)) == %@", author)
            let books = try mainContext.fetch(request)
            for book in books {
                try delete(book)
            }
            author.prepareForDeletion()
            mainContext.delete(author)
            try mainContext.save()
        }
    }
    
    func delete(_ book: BookMO) throws {
        try mainContext.performAndWait {
            // swiftlint:disable:next force_unwrapping
            guard let author = self.mainContext.object(with: book.author!.objectID) as? AuthorMO else {
                return
            }
            author.removeFromBooks(book)
            if author.books?.count == 0 {
                try delete(author)
            }
            
            // swiftlint:disable:next force_unwrapping
            guard let genre = self.mainContext.object(with: book.genre!.objectID) as? GenreMO else {
                return
            }
            genre.removeFromBooks(book)
            book.prepareForDeletion()
            mainContext.delete(book)
            try mainContext.save()
        }
    }
    
    func clearData() throws {
        try mainContext.performAndWait { [unowned self] in
            let authorsRequest = AuthorMO.fetchRequest()
            let allAuthors = try mainContext.fetch(authorsRequest)
            
            let genresRequest = GenreMO.fetchRequest()
            let allGenres = try mainContext.fetch(genresRequest)
            
            let booksRequest = BookMO.fetchRequest()
            let allBooks = try mainContext.fetch(booksRequest)
            
            for book in allBooks {
                for author in allAuthors {
                    author.removeFromBooks(book)
                }
                
                for genre in allGenres {
                    genre.removeFromBooks(book)
                }
            }
            
            delete(allAuthors)
            delete(allGenres)
            delete(allBooks)
            
            try mainContext.save()
        }
    }
    
    private func delete(_ objects: [NSManagedObject]) {
        for object in objects {
            mainContext.delete(object)
        }
    }
}

enum FetchError: String, Error {
    case nothingIsHere = "No entries"
}
