//
//  Extensions.swift
//  todo
//
//  Created by Z.Seckin on 14.01.2022.
//

import UIKit

extension UIViewController {
    
    public func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Button.done, style: .default))
        present(alert, animated: true)
    }
}

extension UITableView {
    
    func setEmptyBackground() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        label.textColor = UIColor.darkText
        label.text = Constants.Button.add
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        self.backgroundView = label
    }
    
    func clearBackground() {
        self.backgroundView = nil
    }
}

extension String {
    var isEmptyString: Bool {
        trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
}
