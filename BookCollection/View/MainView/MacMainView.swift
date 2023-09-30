import SwiftUI

#if os(macOS)
struct MacMainView: View {
    var body: some View {
        NavigationSplitView {
            AuthorsList()
        } content: {
            if let selectedAuthor = selectedStateModel.selectedAuthor {
                AuthorsBooks(author: selectedAuthor)
            } else {
                ZStack { }
            }
        } detail: {
            if let selectedBook = selectedStateModel.selectedBook {
                ZStack { }
            } else {
                ZStack { }
            }
        }
    }
}
#endif
