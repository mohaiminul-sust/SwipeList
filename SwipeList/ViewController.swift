//
//  ViewController.swift
//  SwipeList
//
//  Created by ANDROMEDA on 7/14/16.
//  Copyright © 2016 infancyit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    var items = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        tableview.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.separatorStyle = .None
        tableview.backgroundColor = UIColor.blackColor()
        tableview.rowHeight = 50.0
        
        
        if(items.count < 0){
            return
        }
        
        //populate
        items.append(ToDoItem(text: "buy eggs"))
        items.append(ToDoItem(text: "get more exercise"))
        items.append(ToDoItem(text: "rule the Web"))
        items.append(ToDoItem(text: "catch up with Mom"))
        items.append(ToDoItem(text: "feed the dog"))
        items.append(ToDoItem(text: "irritate people"))
    }
    
    func itemDeleted(item: ToDoItem) {
        let index = (items as NSArray).indexOfObject(item)
        if index == NSNotFound { return }
        
        items.removeAtIndex(index)
        
        tableview.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableview.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableview.endUpdates()
    }
    
    // MARK: - tableview data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        let item = items[indexPath.row]
        
        cell.selectionStyle = .None
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = item.text
        
        cell.delegate = self
        cell.todoitem = item
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableview.rowHeight
    }
    
    //MARK: - tableview delgates
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = items.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }

}

