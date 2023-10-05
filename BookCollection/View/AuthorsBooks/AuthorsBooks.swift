import SwiftUI

struct AuthorsBooks: View {
    private let selectedViewState = SelectedViewState.shared
    @ObservedObject var viewModel = AuthorsBooksViewModel()
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true)],
                  // swiftlint:disable:next force_unwrapping
                  predicate: NSPredicate(format: "%K == %@", #keyPath(Book.author), SelectedViewState.shared.selectedAuthor!),
                  animation: .default)
    private var books: FetchedResults<Book>
    
    // TODO: Make book preview loadable
    var body: some View {
        List(books) { book in
            Text(book.title ?? "")
                .onTapGesture {
                    selectedViewState.selectedBook = book
                }
                .onLongPressGesture {
                    if selectedViewState.selectedBook == book {
                        selectedViewState.selectedBook = nil
                    }
                    viewModel.delete(book: book)
                }
                .accessibilityIdentifier(AccLabels.AuthorsBooks.authorsCell(book.title ?? ""))
        }
        .accessibilityIdentifier(AccLabels.AuthorsBooks.mainList)
    }
}
