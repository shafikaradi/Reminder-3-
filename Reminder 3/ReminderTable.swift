//
//  ReminderList.swift
//  Reminder 3
//
//  Created by Shafiq Aradi on 4/3/16.
//  Copyright © 2016 Shafiq Aradi. All rights reserved.
//

import UIKit
import CoreData

class ReminderTable: UITableViewController,NSFetchedResultsControllerDelegate{

    
    var reminders:[ReminderData] = []
    var fetchResultController:NSFetchedResultsController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reminder"
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        
        // Enable self sizing cells
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController!.toolbarHidden = false;
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        // Enable self sizing cells
        
        // Load the restaurants from database
        let fetchRequest = NSFetchRequest(entityName: "Reminder")
        let sortDescriptor = NSSortDescriptor(key:"time", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                reminders = fetchResultController.fetchedObjects as! [ReminderData]
            } catch {
                print(error)
            }
            
            
            
        }
         self.navigationController!.toolbarHidden = false;
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        self.navigationController!.navigationBarHidden = false
        
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    


    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = fetchResultController.objectAtIndexPath(indexPath)
            as! ReminderData
        
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ReminderListCell
        let dates = fetchResultController.objectAtIndexPath(indexPath)
            as! ReminderData
        // Configure the cell...
        
       
        cell.name.text = reminders[indexPath.row].name
        cell.category.text = reminders[indexPath.row].category
        cell.date.text = dates.stringForDate()
        cell.time.text = dates.stringForTime()
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            reminders.removeAtIndex(indexPath.row)
        }
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Social Sharing Button
        
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "\u{1F5D1}",handler: { (action, indexPath) -> Void in
            
            // Delete the row from the database
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                
                
                let delete  = UIAlertController(title: "Are You Sure You Want Delete this Reminder ?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                
                let Yes = UIAlertAction(title: "Yes", style: .Default) { (action) in
                    
                    let reminderToDelete = self.fetchResultController.objectAtIndexPath(indexPath) as! ReminderData
                    managedObjectContext.deleteObject(reminderToDelete)
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print(error)
                    }
              
                    
                }
                delete.addAction(Yes)
                
                
                let No = UIAlertAction(title: "No", style: .Destructive) { (action) in
                    // ...
                }
                delete.addAction(No)
                
                
                
                self.presentViewController(delete, animated: true) {}
                
              
            }
        })
        
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "\u{2704}",handler: { (action, indexPath) -> Void in
            
            // Delete the row from the database
          
                let st:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc :Reminder = st.instantiateViewControllerWithIdentifier("editReminder") as! Reminder
                self.presentViewController(vc, animated: true, completion: nil)
            
            
        
            
            
        })
        
        // Set the button color
        
        deleteAction.backgroundColor = UIColor(red: 247/255, green: 93/255, blue: 89/255, alpha: 1)
        editAction.backgroundColor = UIColor(red: 21/255, green: 137/255, blue: 255/255, alpha: 1)
        return [deleteAction,editAction]
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation

    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        // 1
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editReminder" {
            
            let task = segue.destinationViewController as! Reminder
            
            
            let indexpath = self.tableView.indexPathForSelectedRow
            
            let row = indexpath?.row
            
            task.reminders = reminders[row!]
          
            
        }
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let _indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Left)
            }
        case .Update:
            if let _indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
            }
            
        default:
            tableView.reloadData()
        }
        
        reminders = controller.fetchedObjects as! [ReminderData]
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    

}
