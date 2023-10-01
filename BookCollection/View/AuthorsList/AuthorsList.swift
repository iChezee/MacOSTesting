import SwiftUI

struct AuthorsList: View {
    private let selectedViewState = SelectedViewState.shared
    @ObservedObject private var viewModel: AuthorsListViewModel
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Author.name, ascending: true)],
                  animation: .default)
    private var authors: FetchedResults<Author>
    
    init(viewModel: AuthorsListViewModel = AuthorsListViewModel()) {
        self.viewModel = viewModel
    }
    
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
                    viewModel.delete(author: author)
                }
                .accessibilityIdentifier(AccLabels.AuthorsList.cellNavigationLink(author.name!)) // swiftlint:disable:this force_unwrapping
        }
        .toolbar {
            Button {
                Task {
                    await viewModel.add("Some name")
                }
            } label: {
                Image(systemName: "plus")
            }
            .accessibilityIdentifier(AccLabels.AuthorsList.addButton)
        }
        .alert(isPresented: $viewModel.hasError, error: viewModel.error) { error in
            if let suggestion = error.recoverySuggestion {
                Button(suggestion, role: .cancel) {
                    viewModel.error = nil
                }
            } else {
                Text("Ok")
            }
        } message: { error in
            if let failureReason = error.failureReason {
                Text(failureReason)
            } else {
                Text("Unknown reason")
            }
        }
        .accessibilityIdentifier(AccLabels.AuthorsList.mainList)
    }
}

#Preview("Empty View") {
    AuthorsList()
        .preferredColorScheme(.dark)
}

#Preview("Has AddItem error") {
    let viewModel = AuthorsListViewModel()
    viewModel.hasError = true
    viewModel.error = .addItem(CocoaError(.coreData))
    return AuthorsList(viewModel: viewModel)
}

#Preview("Has DeleteItem error") {
    let viewModel = AuthorsListViewModel()
    viewModel.hasError = true
    viewModel.error = .deleteItem(CocoaError(.coreData))
    return AuthorsList(viewModel: viewModel)
}
