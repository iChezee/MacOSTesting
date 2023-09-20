import SwiftUI
import CoreData

#if os(iOS)
struct iOSMainView: View {
    private var viewModel = MainViewViewModel()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Author.name, ascending: true)],
                  animation: .default)
    private var items: FetchedResults<Author>
    
    var body: some View {
        NavigationView {
            List(items) { item in
                Text(item.name ?? "")
            }
            .toolbar {
                Button {
                    viewModel.requestNewBook()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    iOSMainView()
}
#endif
