import Foundation

class SelectedViewState: ObservableObject {
    static let shared = SelectedViewState()
    
    @Published var selectedAuthor: Author? {
        didSet {
            if (selectedAuthor?.books.first { $0.id == selectedBook?.id } != nil) {
                selectedBook = nil
            }
        }
    }
    
    @Published var selectedBook: Book?
}
