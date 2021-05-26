//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by admin on 5/25/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //global context
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField?
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let category = Category()
            category.name = alertTextField!.text!
            
            self.saveItem(category)
            self.tableView.reloadData()
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Category name"
            alertTextField = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        
        return cell
    }
    
    //MARK: tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: data manipulation
    
    func saveItem(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categorie, \(error)")
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
}
