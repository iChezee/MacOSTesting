import SwiftUI

struct AuthorsList: View {
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
                .onLongPressGesture {
                    viewModel.delete(author: author)
                }
                .accessibilityIdentifier(AccLabels.AuthorsList.cellNavigationLink(author.name!))
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

#Preview("Added Authors") {
    AuthorsList()
        .preferredColorScheme(.light)
}
