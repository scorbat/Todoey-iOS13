//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by admin on 5/25/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //global context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField: UITextField?
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let category = Category(context: self.context)
            category.name = alertTextField!.text
            
            self.categories.append(category)
            self.tableView.reloadData()
            
            self.saveItems()
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //MARK: tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: data manipulation
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving categorie, \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error loading categories, \(error)")
        }
    }
    
}
