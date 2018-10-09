//
//  ItemTableViewController.swift
//  Core Data Demo
//
//  Created by leon on 2018/10/9.
//  Copyright © 2018年 leonlee. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItem()

    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = itemArray[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        context.delete(itemArray[indexPath.row])
        
        itemArray.remove(at: indexPath.row)
        
        saveItem()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func add(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "ADD", message: "GO TO ADD", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "ok", style: .default) { (action) in
           
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItem()
            
            self.tableView.reloadData()
            
            print(textField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItem(){
        
        do{
            try context.save()
        }catch{
            print("save item error\(error)")
        }
        
    }

    func loadItem(){
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("fetch data error\(error)")
        }
    }

  

}
