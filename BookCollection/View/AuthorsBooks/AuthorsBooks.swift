import SwiftUI

struct AuthorsBooks: View {
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
        }
    }
}
