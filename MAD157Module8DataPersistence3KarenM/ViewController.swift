//
//  ViewController.swift
//  MAD157Module8DataPersistence3KarenM
//
//  Created by Karen Mathes on 10/5/20.
//  Copyright © 2020 TygerMatrix Software. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var enterGuitarDescription: UITextField!
    @IBOutlet var dispDataHere: UITextView!
    
    var dataManager : NSManagedObjectContext!
    //.. array to hold the database info for loading/saving
    var listArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        dispDataHere.text?.removeAll()
        //.. get any initial data if there is some
        fetchData()
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
    
    //.. save to db
    @IBAction func saveRecordButton(_ sender: UIButton) {
        
        //.. for "Item" table in xcdatamodeld
        let newEntity = NSEntityDescription.insertNewObject(forEntityName:"Item", into: dataManager)
        //.. for "about" attribute/field in table "Item" in xcdatamodeld
        newEntity.setValue(enterGuitarDescription.text!, forKey: "about")
        
        do{
            //.. try to save in db
            try self.dataManager.save()
            //.. add new entity to array
            listArray.append(newEntity)
        } catch{
            print ("Error saving data")
        }
        dispDataHere.text?.removeAll()
        enterGuitarDescription.text?.removeAll()
        //.. refetch data to redisplay
        fetchData()
    }
    
    //.. delete from db
    @IBAction func deleteRecordButton(_ sender: UIButton) {
        //.. set the String of what you want to delete
        let deleteItem = enterGuitarDescription.text!
        //.. go through entire array to search for the string you want to delete (deleteItem above)
        for item in listArray {
            //.. if the value for the attribute/field "about" equals deleteItem...
            if item.value(forKey: "about") as! String == deleteItem {
                //.. try to delete the row from what's there
                dataManager.delete(item)
            }
            do {
                //**** not sure why you're re-saving this ??? Doesn't the above do that already?
                //.. re-save to the db
                try self.dataManager.save()
            } catch {
                print ("Error deleting data")
            }
            dispDataHere.text?.removeAll()
            enterGuitarDescription.text?.removeAll()
            //.. refetch data to redisplay text field
            fetchData()
        }
        
    }
    
    //.. read from db
    func fetchData() {
        
        //.. setup fetch from "Item" in xcdatamodeld
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        do {
            //.. try to fetch data
            let result = try dataManager.fetch(fetchRequest)
            //.. set the array equal to the results fetched
            listArray = result as! [NSManagedObject]
            
            //.. for each item in the array, do the following..
            for item in listArray {
                //.. get the value for "about" (attribute/field "about" in xcdatamodeld) and set it equal to var product
                var product = item.value(forKey: "about") as! String
                //.. do a simple concatenation to show all products that were fetched from db
                
//                displayDataHere.text! += product
                print("product = \(product)")
                dispDataHere.text! += ("\(product)\n")
                
            }
        } catch {
            print ("Error retrieving data")
        }
        
    }




}

