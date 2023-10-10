import SwiftUI

#if os(macOS)
struct MacMainView: View {
    @EnvironmentObject var selectedStateModel: SelectedViewState
    
    var body: some View {
        NavigationSplitView {
            AuthorsList()
        } content: {
            if let selectedAuthor = selectedStateModel.selectedAuthor {
                AuthorsBooks(author: selectedAuthor)
            } else {
                EmptyView()
            }
        } detail: {
            if selectedStateModel.selectedBook != nil {
                ZStack { }
            } else {
                ZStack { }
            }
        }
    }
}
#endif
