import SwiftUI
import CoreData
import DependencyInjection
import DataManagment

#if os(iOS)
struct iOSMainView: View { // swiftlint:disable:this type_name
    var body: some View {
        NavigationView {
           AuthorsList()
        }
    }
}

#endif
