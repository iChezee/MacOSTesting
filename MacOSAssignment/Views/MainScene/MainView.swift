import SwiftUI

public struct MainView: View {
    @ObservedObject private var viewModel = MainViewViewModel()
    @ObservedObject private var selectionModel = SelectionModel.shared
    @FetchRequest(entity: GenreMO.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \GenreMO.title, ascending: true)])
    private var genres: FetchedResults<GenreMO>
    
    @State private var isAddGenreOpened = false
    
    public var body: some View {
        topBar
        mainList
    }
    
    var topBar: some View {
        HStack {
            Button {
                isAddGenreOpened.toggle()
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }
            .popover(isPresented: $isAddGenreOpened) {
                AddBookPopover { book, author, genre in
                    viewModel.addBook(title: book, authorName: author, genreTitle: genre)
                    isAddGenreOpened = false
                }
            }
            .accessibilityIdentifier(AccLabels.MainView.addButton)
        }
    }
    
    var mainList: some View {
        List(genres) { model in
            NavigationLink(destination: {
                if selectionModel.selectedGenre != nil {
                    ContentView()
                        .environment(\.managedObjectContext, CoreDataManager.shared.mainContext)
                }
            }, label: {
                Text(model.title ?? "")
            })
            #if os(iOS)
            .isDetailLink(true)
            #endif
            .onTapGesture {
                selectionModel.selectedGenre = model
                selectionModel.selectedAuthor = nil
            }
            .onLongPressGesture {
                if selectionModel.selectedGenre == model {
                    selectionModel.selectedGenre = nil
                }
                viewModel.remove(model)
            }
            .accessibilityIdentifier(AccLabels.MainView.cellNavigationLink(model.title ?? ""))
        }
        .accessibilityIdentifier(AccLabels.MainView.mainList)
    }
}
