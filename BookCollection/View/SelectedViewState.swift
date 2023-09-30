import Foundation

class SelectedViewState: ObservableObject {
    static let shared = SelectedViewState()
    
    @Published var selectedAuthor: Author?
    @Published var selectedBook: Book?
}
