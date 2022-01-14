//
//  Constants.swift
//  todo
//
//  Created by Z.Seckin on 14.01.2022.
//

import UIKit

enum Constants {
    
    static let storyboardName: String = "Main"
    static let cellIdentifier: String = "TodoTableCell"
    
    enum Screen {
        static let listTitle: String = "Todo - List"
        static let detailTitle: String = "Todo - Detail"
    }
    
    enum Warning {
        static let generic: String = "There is an error."
        static let titleField: String = "The title cannot be empty."
    }
    
    enum Button {
        static let update: String = "Update"
        static let done: String = "Done"
        static let add: String = "No data available \nPlease click + button"
    }
}
