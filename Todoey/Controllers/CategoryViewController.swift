//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Artem Mazur on 09.07.2020.
//  Copyright © 2020 Artem Mazur. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavBar dont exist")
        }
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        
    }
    
    
    
    // MARK: -------------TableView DataSource Methods------------
    
    
    //numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Nill  Coalescing Operator
        return categoryArray?.count ?? 1
        
    }
    
    
    // cellForRowAt
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        

        
        
        return cell
        
    }
    

    
    // MARK: -------------Add New Items------------
    
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        // UIAlertController
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        // UIAlertAction
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.saveCategory(category: newCategory)
            
        }
        // addTextField
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        
        // addAction
        alert.addAction(action)
        // present
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: -------------TableView Delegate Methods------------
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    // MARK: -------------Model Manupulation Methods------------
    
    
    //saveCategory
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("saving eroor, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categoryArray = realm.objects(Category.self)
        
        
        tableView.reloadData()
        
    }
    
    // MARK: -------------Delete Data From Swipe------------
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch  {
                print("error during deleting category, \(error)")
            }
        }
    }
    
}

// MARK: -------------SwipeCell Delegate Methods------------

