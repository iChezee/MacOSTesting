import SwiftUI

#if os(macOS)
struct MacMainView: View {
    var body: some View {
        NavigationSplitView {
            Text("Hello")
        } content: {
            Text("Hello")
        } detail: {
            Text("Hello")
        }

    }
}
#endif
