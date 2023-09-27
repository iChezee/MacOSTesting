import SwiftUI

#if os(macOS)
struct MacMainView: View {
    var body: some View {
        NavigationSplitView {
            AuthorsList()
        } content: {
            Text("Hello")
        } detail: {
            Text("Hello")
        }
    }
}
#endif
