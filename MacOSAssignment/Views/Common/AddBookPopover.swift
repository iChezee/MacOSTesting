import SwiftUI

struct AddBookPopover: View {
    @Environment(\.dismiss)
    private var dismiss
    @ObservedObject var viewModel = AddBookPopoverViewModel()
    @State private var notValidFields = false
    @State private var shakeOffset: CGFloat = 0
    
    let completion: (_ book: String, _ author: String, _ genre: String) -> Void
    
    var body: some View {
        VStack {
            topBar
            Divider()
            inputFields
                .padding(.horizontal, 30)
            Spacer()
            Divider()
                .padding(.vertical, Sizes.medium)
            Button {
                notValidFields = !viewModel.validate()
                if notValidFields {
                    shakeOffset = 30
                } else {
                    completion(viewModel.bookTitle, viewModel.authorName, viewModel.genreTitle)
                }
                withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                    shakeOffset = 0
                }
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }
            .padding(.bottom, Sizes.medium)
            .accessibilityIdentifier(AccLabels.AddBookPopover.addButton)
        }
        .offset(x: shakeOffset)
        .frame(minWidth: Sizes.popoverMinimumWidth)
    }
    
    var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
            }
            .accessibilityIdentifier(AccLabels.AddBookPopover.closeButton)
            Spacer()
            Spacer()
        }
        .padding([.horizontal, .top], Sizes.medium)
        .padding(.bottom, Sizes.small)
    }
    
    var inputFields: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Book: ")
                TextField("", text: $viewModel.bookTitle)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier(AccLabels.AddBookPopover.bookTextField)
            }
            
            VStack(alignment: .leading) {
                Text("Author: ")
                TextField("", text: $viewModel.authorName)
                    .textFieldStyle(.roundedBorder)
                    .frame(alignment: .trailing)
                    .accessibilityIdentifier(AccLabels.AddBookPopover.authorTextField)
            }
            
            VStack(alignment: .leading) {
                Text("Genre: ")
                TextField("", text: $viewModel.genreTitle)
                    .textFieldStyle(.roundedBorder)
                    .frame(alignment: .trailing)
                    .accessibilityIdentifier(AccLabels.AddBookPopover.genreTextField)
            }
        }
    }
}
