import SwiftUI

#if os(macOS)
struct MacMainView: View {
    @EnvironmentObject var selectedStateModel: SelectedViewState
    
    var body: some View {
        NavigationSplitView {
            AuthorsList()
        } content: {
            if selectedStateModel.selectedAuthor != nil {
                AuthorsBooks()
            } else {
                ZStack { }
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
