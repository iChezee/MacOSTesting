import SwiftUI
import SwiftData

struct AuthorsBooks: View {
    private let selectedViewState = SelectedViewState.shared
    @Environment(\.modelContext)
    private var context
    
    private let author: Author
    
    @Query(sort: \Book.title,
           animation: .bouncy)
    private var books: [Book]
    
    init(author: Author) {
        let id = author.id
        
        self._books = Query(filter: #Predicate {
            $0.author.id == id
        },
                            sort: \.title,
                            animation: .bouncy)
        
        
        self.author = author
    }
    
    var body: some View {
        List(books) { book in
            Text(book.title)
                .onTapGesture {
                    selectedViewState.selectedBook = book
                }
                .onLongPressGesture {
                    if selectedViewState.selectedBook == book {
                        selectedViewState.selectedBook = nil
                    }
                    context.delete(book)
                }
                .accessibilityIdentifier(AccLabels.AuthorsBooks.authorsCell(book.title))
        }
        .accessibilityIdentifier(AccLabels.AuthorsBooks.mainList)
    }
}
