import SwiftUI
import SwiftData

struct AuthorsList: View {
    private let selectedViewState = SelectedViewState.shared
    @Environment(\.modelContext)
    private var context
    
    @Query(sort: [SortDescriptor(\Author.name)], animation: .bouncy)
    private var authors: [Author]
    
    var body: some View {
        List(authors) { author in
            Text(author.name ?? "")
                .onTapGesture {
                    selectedViewState.selectedAuthor = author
                }
                .onLongPressGesture {
                    if selectedViewState.selectedAuthor == author {
                        selectedViewState.selectedAuthor = nil
                    }
                    context.delete(author)
                }
                .accessibilityIdentifier(AccLabels.AuthorsList.cellNavigationLink(author.name!)) // swiftlint:disable:this force_unwrapping
        }
        .toolbar {
            Button {
                Task {
                    let author = Author()
                    author.name = "Some name"
                    context.insert(author)
                }
            } label: {
                Image(systemName: "plus")
            }
            .accessibilityIdentifier(AccLabels.AuthorsList.addButton)
        }
        .accessibilityIdentifier(AccLabels.AuthorsList.mainList)
    }
}
