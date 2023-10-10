import Foundation
import SwiftData


@Model final class Author {
    var name: String?
    var books: [Book] = []
    
    public init() { }
}
