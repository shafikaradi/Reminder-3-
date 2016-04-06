









import Foundation
import CoreData

class ReminderData : NSManagedObject {
    
    @NSManaged var date: NSDate?
    @NSManaged var name: String?
    @NSManaged var category: String?
    @NSManaged var time : NSDate?
    
    func stringForDate() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        if let date = date {
            return dateFormatter.stringFromDate(date)
        } else {
            return "something went wrong!"
        }
        
        
    }
    
    func stringForTime() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        if let time = time {
            return dateFormatter.stringFromDate(time)
        } else {
            return "something went wrong!"
        }
        
        
    }

    
}




    