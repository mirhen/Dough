//
//  ExpensesTableViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import RealmSwift

class ETVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //--------------------------------------------------//
    
    //Interface Builder User Interface Elements
    
    @IBOutlet weak var amountOfMoneyButton: UIButton!
    @IBOutlet weak var amountTableView: UITableView!
    
    //--------------------------------------------------//
    
    //Non-Interface Builder Objects
    
    //Other Objects
    var balanceDictionary: [Int : Double] = [:]
    var totalBalance = 0.0
    var totalTimeUnit: Int = 0
    var defaultExpenseImages = [UIImage(named: "groceries image.jpg"), UIImage(named: "rent image.jpg"), UIImage(named: "health insurance.jpg"), UIImage(named: "gym image.jpg"), UIImage(named: "phone image.jpg") ]
    var savedExpenseArray: [Expense] = []
    var savedArray = "SavedArray"
    let realm = try! Realm()
    var expenseArray = Results<Expense>?()
        {
        didSet
        {
            let viewController = self.tabBarController?.viewControllers![1] as! HomeViewController
            viewController.expenses = expenseArray
            
            amountTableView.reloadData()
        }
    }
    
    @IBAction func editAmountOfMoneyButtonPressed(sender: AnyObject)
    {
        self.performSegueWithIdentifier("moneyEarnedSegue", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance") != 0
        {
            totalBalance = NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance")
            totalTimeUnit = NSUserDefaults.standardUserDefaults().integerForKey("timeUnit")
        }
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        amountTableView.delegate = self
        amountTableView.dataSource = self
        amountOfMoneyButton.setTitle("$", forState: .Normal)
        
        let firstExpense = Expense()
        firstExpense.amountOfMoney = 10
        firstExpense.expenseName = "groceries"
        firstExpense.itemTag = randomInteger(1, maximumValue: 9999)
        firstExpense.timeUnit = 1
        firstExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "groceries image.jpg")!)!
        
        let secondExpense = Expense()
        secondExpense.amountOfMoney = 10
        secondExpense.expenseName = "rent"
        secondExpense.itemTag = randomInteger(1, maximumValue: 9999)
        secondExpense.timeUnit = 1
        secondExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "rent image.jpg")!)!
        
        let thirdExpense = Expense()
        thirdExpense.amountOfMoney = 10
        thirdExpense.expenseName = "health insurance"
        thirdExpense.itemTag = randomInteger(1, maximumValue: 9999)
        thirdExpense.timeUnit = 1
        thirdExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "health insurance.jpg")!)!
        
        let fourthExpense = Expense()
        fourthExpense.amountOfMoney = 10
        fourthExpense.expenseName = "gym"
        fourthExpense.itemTag = randomInteger(1, maximumValue: 9999)
        fourthExpense.timeUnit = 1
        fourthExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "gym image.jpg")!)!
        
        let fifthExpense = Expense()
        fifthExpense.amountOfMoney = 10
        fifthExpense.expenseName = "phone"
        fourthExpense.itemTag = randomInteger(1, maximumValue: 9999)
        fifthExpense.timeUnit = 1
        fifthExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "phone image.jpg")!)!
        
        expenseArray = RealmHelper.retrieveExpense()
        
        print("expenseArray- \(expenseArray)")
        
        if RealmHelper.retrieveExpense().count == 0
        {
            RealmHelper.addExpense(firstExpense)
            RealmHelper.addExpense(secondExpense)
            RealmHelper.addExpense(thirdExpense)
            RealmHelper.addExpense(fourthExpense)
            RealmHelper.addExpense(fifthExpense)
        }
        expenseArray = RealmHelper.retrieveExpense()
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).expenseArray = expenseArray
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if totalBalance != 0
        {
            if Int(String(totalBalance).componentsSeparatedByString(".")[1]) == 0 && totalTimeUnit == 1
            {
                amountOfMoneyButton.setTitle("$" + String(Int(CalendarUnitHelper.convertToBalancePerWeek(totalTimeUnit, amountOfMoney: totalBalance))), forState: .Normal)
                
                let viewController = self.tabBarController?.viewControllers![1] as! HomeViewController
                viewController.totalTimeUnit = totalTimeUnit
                viewController.totalMoney = totalBalance
            }
            else
            {
                amountOfMoneyButton.setTitle("$" + String(CalendarUnitHelper.convertToBalancePerWeek(totalTimeUnit, amountOfMoney: totalBalance)), forState: .Normal)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        let viewController = self.tabBarController?.viewControllers![1] as! HomeViewController
        
        viewController.expenses = expenseArray
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return expenseArray!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return self.view.frame.height/3.5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! MoneyTableViewCell
        
        print("tableView: cellForRowAtIndexPath array: \(expenseArray!.count)")
        
        cell.titleLabel.text = expenseArray![indexPath.row].expenseName ?? "title"
        var money = CalendarUnitHelper.convertToFormattedDouble(expenseArray![indexPath.row].amountOfMoney)
        money = CalendarUnitHelper.convertToBalancePerWeek(expenseArray![indexPath.row].timeUnit, amountOfMoney: money)
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.locale = NSLocale(localeIdentifier: "es_US")
        
        cell.moneyAmountLabel.text = "\(currencyFormatter.stringFromNumber(money)!) / Week"
        
        cell.expenseImageView.image = CalendarUnitHelper.convertNSDataToUIImage(expenseArray![indexPath.row].expenseImage)
        
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            RealmHelper.deleteExpense(expenseArray![indexPath.row])
            expenseArray = RealmHelper.retrieveExpense()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindToListNotesViewController(segue: UIStoryboardSegue)
    {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "editExpensesPush"
        {
            let destinationController = segue.destinationViewController as! AOEC
            let indexPath = amountTableView.indexPathForSelectedRow
            
            destinationController.currentExpense = expenseArray![indexPath!.row]
            
            print("editExpensesPush")
        }
        else if segue.identifier == "newExpensePush"
        {
            print("newExpensePush")
        }
        else if segue.identifier == "moneyEarnedSegue"
        {
            let destinationController = segue.destinationViewController as! AmountOfMoney
            
            if totalBalance != 0.0
            {
                destinationController.testBalance = CalendarUnitHelper.convertToBalancePerWeek(totalTimeUnit, amountOfMoney: totalBalance)
            }
            print("moneyEarnedSegue")
        }
    }
}