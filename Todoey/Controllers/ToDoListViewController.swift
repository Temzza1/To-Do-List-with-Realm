//
//  ViewController.swift
//  To-Do-List-WithCoreData
//
//  Created by Artem Mazur on 07.07.2020.
//  Copyright © 2020 Artem Mazur. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var toDoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
         if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {
                fatalError("NavBar dont exist")
            }
            
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.backgroundColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:  ContrastColorOf(navBarColor, returnFlat: false) ]
                searchBar.barTintColor = UIColor(hexString: colorHex)
                searchBar.searchTextField.backgroundColor = .white
            }
        
        }
    }
    
    
    
    // MARK: -------------TableView DataSource Methods------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        return cell
        
    }
    
    // MARK: -------------TableView Delegate Methods------------
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                    //                    realm.delete(item) // для удаления по клику
                }
            } catch {
                print("error saving done status, \(error)")
            }
            
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: -------------Add New Items------------
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user click
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error saving items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            print("good, \(textField.text ?? "New Item")")
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    // MARK: -------------Model Manupulation Methods------------
    
    
    
    func loadItems()  { // после = это дефолтное значение
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    
    
    
    // MARK: -------------Delete Items with Swipe------------
    
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let deletedItem = self.selectedCategory?.items[indexPath.row] {
            do {
                try self.realm.write {
                    
                    realm.delete(deletedItem)
                }
            } catch  {
                print("error with deleting item, \(error)")
            }
        }
    }
    
}

// MARK: -------------Search Bar Methods------------
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
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





