import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewViewModel()
    private let selectionModel = SelectionModel.shared
    
    @FetchRequest(entity: BookMO.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "\(#keyPath(BookMO.genre)) == %@", SelectionModel.shared.selectedGenre ?? "")
    )
    private var books: FetchedResults<BookMO>
    
    var body: some View {
        VStack {
            if let genre = selectionModel.selectedGenre {
                Text("Selected genre: \(genre.title ?? "")")
                    .padding([.top, .horizontal], Sizes.small)
            }
            // swiftlint:disable:next closure_spacing
            let authors = books.compactMap { $0.author }.sorted { $0.name ?? "" < $1.name ?? ""}
            List(authors) { model in
                NavigationLink {
                    if selectionModel.selectedAuthor != nil {
                        DetailedView()
                            .environment(\.managedObjectContext, CoreDataManager.shared.mainContext)
                    }
                } label: {
                    Text(model.name ?? "")
                }
#if os(iOS)
                .isDetailLink(true)
#endif
                .onTapGesture {
                    selectionModel.selectedAuthor = model
                }
                .onLongPressGesture {
                    selectionModel.selectedAuthor = nil
                    viewModel.remove(model)
                }
            }
        }
    }
}
