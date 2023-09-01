import SwiftUI

struct DetailedView: View {
    let viewModel = DetailedViewViewModel()
    
    @FetchRequest(entity: BookMO.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "\(#keyPath(BookMO.title))", ascending: true)],
                  predicate: NSPredicate(format: "\(#keyPath(BookMO.author)) == %@", SelectionModel.shared.selectedAuthor ?? ""))
    private var books: FetchedResults<BookMO>
    
    var body: some View {
        VStack {
            if let author = SelectionModel.shared.selectedAuthor {
                Text("Selected author: \(author.name ?? "")")
                    .padding([.top, .horizontal], Sizes.small)
            }
            List(books) { model in
                Text(model.title ?? "")
                    .onLongPressGesture {
                        viewModel.remove(model)
                    }
            }
        }
    }
}
