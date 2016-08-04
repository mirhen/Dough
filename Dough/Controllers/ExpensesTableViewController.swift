//
//  ExpensesTableViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

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
    var editedExpenseImages: [UIImage] = []
    var savedExpenseArray: [Expense] = []
    var savedArray = "SavedArray"
    var expenseArray: [Expense] = []
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
        
        
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        amountTableView.delegate = self
        amountTableView.dataSource = self
        amountOfMoneyButton.setTitle("$", forState: .Normal)
        
        let firstExpense = Expense(amountOfMoney: 20, expenseName: "groceries", itemTag: randomInteger(1, maximumValue: 9999), timeUnit: 1, expenseImage: UIImage(named: "groceries image.jpg")!)
        
        let secondExpense = Expense(amountOfMoney: 20, expenseName: "rent", itemTag: randomInteger(1, maximumValue: 9999), timeUnit: 1, expenseImage: UIImage(named: "rent image.jpg")!)
        
        let thirdExpense = Expense(amountOfMoney: 20, expenseName: "health insurance", itemTag: randomInteger(1, maximumValue: 9999), timeUnit: 1, expenseImage: UIImage(named: "health insurance.jpg")!)
        
        let fourthExpense = Expense(amountOfMoney: 20, expenseName: "gym", itemTag: randomInteger(1, maximumValue: 9999), timeUnit: 1, expenseImage: UIImage(named: "gym image.jpg")!)
        
        let fifthExpense = Expense(amountOfMoney: 20, expenseName: "phone", itemTag: randomInteger(1, maximumValue: 9999), timeUnit: 1, expenseImage: UIImage(named: "phone image.jpg")!)
        
        expenseArray.append(firstExpense)
        expenseArray.append(secondExpense)
        expenseArray.append(thirdExpense)
        expenseArray.append(fourthExpense)
        expenseArray.append(fifthExpense)
        //        let defaults = NSUserDefaults.standardUserDefaults()
        //
        //        //To reset array
        //        defaults.setObject(nil, forKey: savedArray)
        //
        //        if let decoded = defaults.objectForKey(savedArray) as? NSData {
        //            expenseArray.removeAll()
        //
        //            let decodedExpenseArray = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as! [Expense]
        //            print("decodedExpenseArray: \(decodedExpenseArray)")
        //            for individualObject in decodedExpenseArray {
        //                expenseArray.append(individualObject)
        //                print("individualObject in expense array: \(individualObject)")
        //            }
        //
        //        }
        
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
        //        let defaults = NSUserDefaults.standardUserDefaults()
        //        if expenseArray != [] {
        //            let data = NSKeyedArchiver.archivedDataWithRootObject(expenseArray)
        //            print("data: \(data)")
        //            defaults.setObject(data, forKey: savedArray)
        //            defaults.synchronize()
        //            savedExpenseArray = expenseArray
        //        }
        
        let viewController = self.tabBarController?.viewControllers![1] as! HomeViewController
        viewController.expenses.removeAll()
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
        return expenseArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! MoneyTableViewCell
        
        print("tableView: cellForRowAtIndexPath array: \(expenseArray.count)")
        
        cell.titleLabel.text = expenseArray[indexPath.row].expenseName ?? "title"
        cell.backgroundColor = colorWithHexString("#F89D21")
        var money = CalendarUnitHelper.convertToFormattedDouble(expenseArray[indexPath.row].amountOfMoney!)
        money = CalendarUnitHelper.convertToBalancePerWeek(expenseArray[indexPath.row].timeUnit!, amountOfMoney: money)
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.locale = NSLocale(localeIdentifier: "es_US")
        
        cell.moneyAmountLabel.text = "\(currencyFormatter.stringFromNumber(money)!) / Week"
        
        cell.expenseImageView.image = expenseArray[indexPath.row].expenseImage
        
        return cell
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
            
            destinationController.currentExpense = expenseArray[indexPath!.row]
            
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
