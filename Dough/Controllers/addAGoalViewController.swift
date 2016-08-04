//
//  addAGoalViewController.swift
//  Gimme Dough
//
//  Created by Miriam Hendler on 7/12/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

class addAGoalViewController: UIViewController
{
    //--------------------------------------------------//
    
    //Interface Builder User Interface Elements
    
    //UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //Other Items
    @IBOutlet weak var addAGoal: UILabel!
    
    
    //Non-Interface Builder Objects
    
    //Other Objects
    var spendingMoney: Double = 0
    var timeUnit = 4
    var goals = ["Custom goal", "Save up", "Payoff Debt"]
    var goalDescriptions = ["Save money up for a your custom goal", "Save up money", "Help payoff debt that you have for a certain time"]
    var goalIcons = [UIImage(named: "non transparent goal icon 3.png"), UIImage(named: "non transparent goal icon 2.png"), UIImage(named: "non transparent goal icon 1 .png")]
    
    //--------------------------------------------------//
    
    //Override Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "money background.png")!)
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "cheating xcode patern.png")!)

        // Do any additional setup after loading the view.
    }
}

//MARK: Table View Delegate

    extension addAGoalViewController: UITableViewDelegate, UITableViewDataSource
    {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return goals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("goalIdentifier", forIndexPath: indexPath) as! GoalTableViewCell
        
        cell.titleLabel.text = goals[indexPath.row]
        cell.descriptionLabel.text = goalDescriptions[indexPath.row]
        cell.imageView?.image = goalIcons[indexPath.row]
        cell.backgroundColor =  UIColor(patternImage: UIImage(named: "cheating xcode patern.png")!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return tableView.frame.height/3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        self.performSegueWithIdentifier("setGoalPush", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "setGoalSegue"
        {
            let destination = segue.destinationViewController as! SetAGoalViewController
            
            destination.timeUnitOfMoney = timeUnit
            destination.spendingMoney = spendingMoney
            
            print("going to set a goal view")
        }
    }
}
