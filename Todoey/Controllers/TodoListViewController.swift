//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var items: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK: tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        //toggle done status
//        items?[indexPath.row].done = !items?[indexPath.row].done
//
          tableView.reloadData()
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() //local way to store text entered by user in alert popup
        
        let alert = UIAlertController(title: "add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let current = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.dateCreated = Date()
                        current.items.append(item)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //store outside of scope to be used in action handler
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model manipulation methods
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
}

//MARK: search bar delegate methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

