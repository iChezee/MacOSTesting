//
//  Author.swift
//  
//
//  Created by ILLIA HOREVOI on 05.10.2023.
//
//

import Foundation
import SwiftData


@Model final class Author {
    var name: String?
    var books: [Book] = []
    
    public init() { }
}
