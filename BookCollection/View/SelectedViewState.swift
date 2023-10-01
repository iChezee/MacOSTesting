import Foundation

class SelectedViewState: ObservableObject {
    static let shared = SelectedViewState()
    
    @Published var selectedAuthor: Author? {
        didSet {
            if (selectedAuthor?.books?.contains(selectedBook as Any)) != nil {
                selectedBook = nil
            }
        }
    }
    
    @Published var selectedBook: Book?
}
