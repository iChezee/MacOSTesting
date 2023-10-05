import SwiftUI

#if os(iOS)
struct iOSMainView: View { // swiftlint:disable:this type_name
    var body: some View {
        NavigationView {
           AuthorsList()
        }
    }
}

#endif
