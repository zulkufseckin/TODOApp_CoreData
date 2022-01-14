//
//  TodoTableCell.swift
//  todo
//
//  Created by Z.Seckin on 14.01.2022.
//

import UIKit

final class TodoTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func set(_ title: String?) {
        titleLabel.text = title
    }
}
