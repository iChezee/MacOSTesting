//
//  MainRouter.swift
//  BookCollection
//
//  Created by ILLIA HOREVOI on 05.10.2023.
//

import Foundation
import SwiftUI
import DependencyInjection
import ViewRouting

typealias RootRouter = ViewRouter<RootRouterViewBuilder>

protocol ViewOrder {
    var viewOrder: Int { get }
}

// RootSceneDestination: SceneDestination
enum RootViewState: ViewOrder, ViewState {
    case mainScreen
    case authorsList
    case authorsBooks(author: Author)
    case bookText(text: String)
    
    var viewOrder: Int {
        switch self {
        case .mainScreen: return 0
        case .authorsList: return 1
        case .authorsBooks: return 2
        case .bookText: return 3
        }
    }
}

struct RootRouterViewBuilder: ViewRouterBuilder {
    @ViewBuilder
    func build(state: RootViewState) -> some View {
        switch state {
        case .mainScreen:
            iOSMainView()
        case .authorsList:
            AuthorsList()
        case .authorsBooks(let author):
            AuthorsBooks(author: author)
        case .bookText(let text):
            BookText(bookText: text)
        }
    }
}
