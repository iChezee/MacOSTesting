import Foundation

public enum AccLabels {
    public enum MainView {
        public static let addButton = "AddButton"
        public static let mainList = "MainList"
        public static func cellNavigationLink(_ modelName: String) -> String {
            "CellNavigationLink\(modelName)"
        }
    }
    
    enum AddBookPopover {
        static let bookTextField = "BookTextField"
        static let authorTextField = "AuthorTextField"
        static let genreTextField = "GenreTextField"
        static let addButton = "AddBookPopover.AddButton"
    }
}
