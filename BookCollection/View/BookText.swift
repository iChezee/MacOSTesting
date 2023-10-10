import SwiftUI

struct BookText: View {
    let bookText: String
    
    var body: some View {
        ZStack {
           Text(bookText)
        }
    }
}
