//
//  DetailViewController.swift
//  todo
//
//  Created by Z.Seckin on 14.01.2022.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func currentItem(item: Item, index: Int, status: Status)
}

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var saveUpdateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: DetailViewControllerDelegate?
    var item: Item?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.Screen.detailTitle
        titleTextField.delegate = self
        detailsTextView.delegate = self
        setUI()
    }
    
    func setUI() {
        if let item = item {
            titleTextField.text = item.title
            detailsTextView.text = item.details
            saveUpdateButton.setTitle(Constants.Button.update, for: .normal)
        } else {
            deleteButton.isHidden = true
        }
        detailsTextView.layer.borderWidth = 1
        detailsTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmptyString else { showAlert(message: Constants.Warning.titleField)
            return
        }
        
        if let item = item {
            item.title = titleTextField.text
            item.details = detailsTextView.text
            CoreDataManager.shared.updateItem( { [weak self] result in
                switch result {
                case .success:
                    self?.delegate?.currentItem(item: item, index: (self?.index)!, status: .update)
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            })
        } else {
            CoreDataManager.shared.createItem(title: title, details: detailsTextView.text, { [weak self] result in
                switch result {
                case .success(let item):
                    self?.delegate?.currentItem(item: item!, index: .zero, status: .new)
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        CoreDataManager.shared.deleteItem(item: item!, { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.currentItem(item: (self?.item)!, index: (self?.index)!, status: .delete)
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        })
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 30
    }
}

extension DetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 150
    }
}
