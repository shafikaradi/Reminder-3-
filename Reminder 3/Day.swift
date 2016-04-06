//
//  Day.swift
//  Reminder 3
//
//  Created by Shafiq Aradi on 3/29/16.
//  Copyright © 2016 Shafiq Aradi. All rights reserved.
//

import UIKit

class Day: UITableViewController{
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "LabelCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
        return cell
    }
}
