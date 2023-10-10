//
//  Book.swift
//  
//
//  Created by ILLIA HOREVOI on 05.10.2023.
//
//

import Foundation
import SwiftData


@Model
public class Book {
    var imageURL: URL?
    var text: String?
    var title: String
    var author: Author
    
    init(imageURL: URL? = nil, text: String? = nil, title: String, author: Author) {
        self.imageURL = imageURL
        self.text = text
        self.title = title
        self.author = author
    }
}
