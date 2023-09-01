import Foundation
import CoreData

@MainActor
class SelectionModel: ObservableObject {
    static let shared = SelectionModel()
    private init() { }
    
    @Published var selectedGenre: GenreMO?
    @Published var selectedAuthor: AuthorMO?
}
