//
//  DayCell.swift
//  Reminder 3
//
//  Created by Shafiq Aradi on 3/29/16.
//  Copyright © 2016 Shafiq Aradi. All rights reserved.
//

import UIKit
import CoreData
struct ReminderData1{
    var name: String?
    var day: String?
    var rating: Int
    
    init(name: String?, day: String?, rating: Int) {
        self.name = name
        self.day = day
        self.rating = rating
    }
}



class Reminder: UITableViewController,NSFetchedResultsControllerDelegate,UITextFieldDelegate{
//,UIPickerViewDataSource, UIPickerViewDelegate {
    var day:String = " " {
        didSet {
            detailLabel.text? = day
        }
    }
    
    var reminders:ReminderData!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchResultController:NSFetchedResultsController!
    let datePicker = UIDatePicker()
    var time:String!=""
    var storingCategory:String?
    var daySelect:ReminderData1?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var category: UISegmentedControl!
    
    @IBOutlet weak var timePick: UIDatePicker!
   
    
    func viewDidAppear() {
        super.viewDidLoad()
        //Acquaintances
    }
    
 

   



    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTextField.delegate = self
        nameTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        
        if let reminderContent = reminders
            
        {
            
            nameTextField.text = reminderContent.name
            storingCategory = reminderContent.category
          dateTextField.text = reminderContent.stringForDate()
            timePick.date = reminderContent.time!
            
            if(storingCategory == "Task"){
                category.selectedSegmentIndex = 0
            }else if(storingCategory == "Medication"){
                category.selectedSegmentIndex = 1
            }else{
                category.selectedSegmentIndex = 2
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            dateFormatter.stringFromDate(reminderContent.date!)
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "hh:mma"
            timeFormatter.stringFromDate(reminderContent.time!)
            
        
    }
    
       
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
       
        datePicker.datePickerMode = UIDatePickerMode.Date
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: .ValueChanged)
        datePicker.backgroundColor = UIColor.whiteColor()
        
        
    
       
     
    }
    
   
  
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    

    func datePickerChanged(sender:UIDatePicker){
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        dateTextField.text = formatter.stringFromDate(sender.date)
        
        
    }
    


    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SavePlayerDetail" {
            daySelect = ReminderData1(name: nameTextField.text, day:day, rating: 1)
        }
        if segue.identifier == "PickDays" {
            if let dayPickerViewController = segue.destinationViewController as? Days {
                dayPickerViewController.selectedDay = day
            }
        }
    }
    
    func inserte(){
      
        let storingName = nameTextField.text
        //let dateHolder = NSData()
        
        
     
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.dateFromString(dateTextField.text!)
        
        
        
        
        
      print(dateTextField.text)
        print(time)
        
        if reminders == nil {
            
            
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                reminders = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: managedObjectContext) as? ReminderData
                
                reminders!.name = storingName!
                if let categoryStorage = storingCategory{
                reminders.category = categoryStorage
                }
                reminders.date = date
                reminders.time = timePick.date
                
                
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                    return
                }
            }
          
            
           self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
    
    func update(){
        
        let storingName = nameTextField.text
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.dateFromString(dateTextField.text!)
        
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Reminder", inManagedObjectContext: managedObjectContext)
        fetchRequest.includesPropertyValues = true
        
        
        do {
            _ = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [ReminderData]
            reminders.name = storingName
            if let categoryStorage = storingCategory{
                reminders.category = categoryStorage
            }
            
            reminders.date = date
            reminders.time = timePick.date
        
        } catch {
           
        }
      
        
        
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func save(sender:UIBarButtonItem) {
    
        
        
        
 
        if nameTextField.text == "" || dateTextField.text == "" || time=="" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        } else if reminders == nil {
            inserte()
           // update()
            
        }else{
            update()
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //Unwind segue
    @IBAction func unwindWithSelectedDay(segue:UIStoryboardSegue) {
        if let dayPickerViewController = segue.sourceViewController as? Days,
            selectedDay = dayPickerViewController.selectedDay {
                day = selectedDay
        }
    }
    

    @IBAction func backToReminderList(sender: AnyObject) {
        
        
     
    }
   
    
    @IBAction func timePicker(sender: UIDatePicker) {
        
        let timer = timePick.date
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "hh:mma"
         time = timeFormatter.stringFromDate(timer)
        
        
        
        
    }
    
    
    
    @IBAction func selectCategory(sender: UISegmentedControl) {
        
        if category.selectedSegmentIndex == 0{
            storingCategory = "Task"
            
        }else if category.selectedSegmentIndex == 1{
            storingCategory = "Medication"
            
        }else if category.selectedSegmentIndex == 2{
            storingCategory = "Appointment"
            
        }

    }
    
    @IBAction func backToReminderTable(sender : UIBarButtonItem){
self.navigationController?.popViewControllerAnimated(true)
        }
    
    


}



