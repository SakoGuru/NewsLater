//
//  RemindersViewController.swift
//  NewsLater
//
//  Created by Mike on 4/16/15.
//  Copyright (c) 2015 Matt Zuzolo. All rights reserved.
//

import UIKit

class RemindersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var doneBut: UIBarButtonItem!
    @IBOutlet weak var reminderTable: UITableView!
    
    //default values on first launch
    var reminders:[String] = ["Select to set"]
    var newDay: String?
    var newHour: String?
    var setReminder: Bool = false
    //use NSDictionary to save and load when user exit and launch app
    var switchStatus: Bool = false
    var preDay: String = "0"
    var preHour: String = "00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveData", name: "kSaveSwitchesStatesNotification", object: nil);
        
        //loads previously saved time interval to array
        if(preDay == "0" && preHour == "00"){
            reminders[0] = "Select to set"
        }else{
            reminders[0] = "\(preDay) day(s)  \(preHour) hour(s)"
        }
        setDone()
        newDay = preDay
        newHour = preHour
    }
    
    override func viewWillAppear(animated: Bool) {
        reminderTable.reloadData()
        setDone()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: NSString?
        var cell:UITableViewCell?
        
        if(indexPath.section == 0){
            cellIdentifier = "staticCellType"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as! String, forIndexPath: indexPath) as? UITableViewCell
            cell!.textLabel?.text = "Remind me to come back"
            
            var reminderSwitch=UISwitch(frame:CGRectMake(150, 300, 0, 0));
            cell?.accessoryView = reminderSwitch
            reminderSwitch.on = switchStatus
            reminderSwitch.setOn(switchStatus, animated: false);
            reminderSwitch.addTarget(self, action: "switchValueDidChange:", forControlEvents: .ValueChanged);
            self.view.addSubview(reminderSwitch);
            
        }else if(indexPath.section == 1){
            //if switch is off, cell should not be clickable
            if(switchStatus == false){
                cellIdentifier = "dynamicCellType"
                cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as! String, forIndexPath: indexPath) as? UITableViewCell
                cell!.textLabel?.text = "Come back in"
                cell!.detailTextLabel?.text = reminders[indexPath.row]
                cell!.textLabel?.textColor = UIColor.grayColor()
                cell!.detailTextLabel?.textColor = UIColor.grayColor()
                cell!.userInteractionEnabled = false
                
            }else if(switchStatus == true){
                cellIdentifier = "dynamicCellType"
                cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as! String, forIndexPath: indexPath) as? UITableViewCell
                cell!.textLabel?.text = "Come back in"
                cell!.detailTextLabel?.text = reminders[indexPath.row]
                cell!.textLabel?.textColor = UIColor.blackColor()
                cell!.detailTextLabel?.textColor = UIColor.redColor()
                cell!.userInteractionEnabled = true
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section != 0) {
            performSegueWithIdentifier("toPicker", sender: self)
        }
    }
    
    func switchValueDidChange(sender:UISwitch!)
    {
        if (sender.on == true){
            switchStatus = true
            setDone()
            reminderTable.reloadData()
        }
        else{
            switchStatus = false
            setDone()
            reminderTable.reloadData()
        }
    }
    
    func setString(day: String, hour: String){
        var newReminder: String?
        
        newDay = day
        newHour = hour
        if (day == "0" && hour == "00"){
            newReminder = "Select to set"
            setReminder = false
        }else{
            newReminder = "\(day) day(s)  \(hour) hour(s)"
            setReminder = true
        }
        
        reminders[0] = newReminder!
    }
    
    func setDone(){
        if(switchStatus == true){
            if(setReminder == true){
                doneBut.enabled = true
            }else{
                doneBut.enabled = false
            }
        }else{
            doneBut.enabled = true
        }
    }
    
    func saveData(){
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(newDay, forKey: "day")
        defaults.setObject(newHour, forKey: "hour")
        defaults.setBool(switchStatus, forKey: "switchStat")
        defaults.setBool(setReminder, forKey: "reminderStat")
        defaults.synchronize()
        
    }
    
    func loadData(){
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let dayIsNotNil = defaults.objectForKey("day") as? String {
            preDay = defaults.objectForKey("day") as! String
        }
        if let hourIsNotNill = defaults.objectForKey("hour") as? String {
            preHour = defaults.objectForKey("hour") as! String
        }
        if let switchIsNotNill = defaults.objectForKey("switchStat") as? Bool {
            switchStatus = defaults.objectForKey("switchStat") as! Bool
        }
        if let setReminderIsNotNill = defaults.objectForKey("reminderStat") as? Bool {
            setReminder = defaults.objectForKey("reminderStat") as! Bool
        }
    }
    
    func sendNotification(day: String, hour: String) {
        
        var d: Double = (day as NSString).doubleValue
        var h: Double = (hour as NSString).doubleValue
        //convert reminder time interval to seconds
        //var s: Double = (h * 60 * 60) + (d * 24 * 60 * 60)
        var s: Double = 10
        
        var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: s)
        localNotification.alertBody = "Come back to read more news!"
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func removeNotification(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    @IBAction func setReminder(sender: AnyObject) {
        if(switchStatus == true){
            if(setReminder == true){
                removeNotification()
                //if no new reminder time is set, set notification to previously saved time
                if(newDay == nil || newHour == nil){
                    sendNotification(preDay, hour: preHour)
                }else{
                    sendNotification(newDay!, hour: newHour!)
                }
            }
            //save status
            saveData()
            //unwind segue
            performSegueWithIdentifier("returnToFeed", sender: self)
            
        }else{
            removeNotification()
            saveData()
            performSegueWithIdentifier("returnToFeed", sender: self)
        }
    }
    
    @IBAction func returnToReminderList(segue: UIStoryboardSegue) {
    }
    
    @IBAction func saveToReminderList(segue: UIStoryboardSegue) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toPicker") {
            var destinationViewController = segue.destinationViewController as! ReminderPickerViewController
            if(newDay == nil && newHour == nil){
                destinationViewController.preDay = preDay
                destinationViewController.preHour = preHour
            }else{
                destinationViewController.preDay = newDay
                destinationViewController.preHour = newHour
            }
        }
        
    }

    
}

