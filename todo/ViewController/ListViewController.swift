//
//  ListViewController.swift
//  todo
//
//  Created by Z.Seckin on 14.01.2022.
//

import UIKit

final class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.Screen.listTitle
        setupTableView()
        addRightBarButtonItem()
        
        CoreDataManager.shared.getAllItems( { [weak self] result in
            switch result {
            case .success(let items):
                self?.items = items
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addLabelIfNeeded()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapRightBarButtonItem))
    }
    
    @objc func didTapRightBarButtonItem() {
        guard let vc = UIStoryboard.init(name: Constants.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        vc.delegate = self
        show(vc, sender: self)
    }
    
    func addLabelIfNeeded() {
        items.count == 0 ? tableView.setEmptyBackground() : tableView.clearBackground()
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TodoTableCell.self), for: indexPath) as? TodoTableCell else { fatalError("Wrong type of cell") }
        
        let item = self.items[indexPath.row]
        cell.set(item.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = UIStoryboard.init(name: Constants.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        vc.delegate = self
        let index = indexPath.row
        let item = self.items[index]
        vc.index = index
        vc.item = item
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let item = items[indexPath.row]
            CoreDataManager.shared.deleteItem(item: item, { [weak self] result in
                switch result {
                case .success:
                    tableView.performBatchUpdates({
                        self?.items.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }, completion: nil)
                    self?.addLabelIfNeeded()
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            })
        }
    }
    
}

extension ListViewController: DetailViewControllerDelegate {
    
    func currentItem(item: Item, index: Int, status: Status) {
        switch status {
        case .update:
            tableView.performBatchUpdates({
                tableView.reloadRows(at: [IndexPath(row: index,
                                                    section: .zero)], with: .automatic)
            }, completion: nil)
        case .delete:
            tableView.performBatchUpdates({
                self.items.remove(at: index)
                tableView.deleteRows(at: [IndexPath(row: index,
                                                    section: .zero)], with: .automatic)
            }, completion: nil)
        case .new:
            tableView.performBatchUpdates({
                self.items.append(item)
                tableView.insertRows(at: [IndexPath(row: self.items.count - 1,
                                                    section: .zero)], with: .automatic)
            }, completion: nil)
        }
    }
    
}

enum Status {
    case update
    case delete
    case new
}
