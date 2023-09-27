import SwiftUI
import CoreData
import DependencyInjection
import DataManagment

#if os(iOS)
struct iOSMainView: View {
    var body: some View {
        NavigationView {
           AuthorsList()
        }
    }
}

#endif
