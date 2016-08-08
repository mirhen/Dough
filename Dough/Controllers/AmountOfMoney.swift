//
//  AmountOfMoney.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import RealmSwift

class AmountOfMoney: UIViewController
{
    
    @IBOutlet weak var moneyEarnedTextField: UITextField!
    @IBOutlet weak var moneyImageView: UIImageView!
    
    var testBalance: Double = 0
    var timeUnit: Int = 0
    var balanceDictionary: [Int : Double] = [:]
    
    
    
    //UIViews
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var yearView: UIView!
    
    //Action Objects
    @IBAction func dayButtonPressed(sender: AnyObject) {
        dayView.hidden = false
        monthView.hidden = true
        weekView.hidden = true
        yearView.hidden = true
        
        if moneyEarnedTextField.text != "$"
        {
            balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[0]] = CalendarUnitHelper.convertToFormattedDouble(moneyEarnedTextField.text!)
            
            let balanceEntered = balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[0]]
            let dateType = CalendarUnitHelper.timeUnits.map {$0.0}[0]
            
            print("The user has selected $\(balanceEntered!) per every \(CalendarUnitHelper.convertToDateTypeString(dateType)).")
        }
    }
    
    @IBAction func weekButtonPressed(sender: AnyObject)
    {
        dayView.hidden = true
        monthView.hidden = true
        weekView.hidden = false
        yearView.hidden = true
        
        if moneyEarnedTextField.text != "$"
        {
            balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[1]] = CalendarUnitHelper.convertToFormattedDouble(moneyEarnedTextField.text!)
            
            let balanceEntered = balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[1]]
            let dateType = CalendarUnitHelper.timeUnits.map {$0.0}[1]
            
            print("The user has selected $\(balanceEntered!) per every \(CalendarUnitHelper.convertToDateTypeString(dateType)).")
        }
    }
    
    @IBAction func monthButtonPressed(sender: AnyObject)
    {
        dayView.hidden = true
        monthView.hidden = false
        weekView.hidden = true
        yearView.hidden = true
        
        if moneyEarnedTextField.text != "$"
        {
            balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[2]] = CalendarUnitHelper.convertToFormattedDouble(moneyEarnedTextField.text!)
            
            let balanceEntered = balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[2]]
            let dateType = CalendarUnitHelper.timeUnits.map {$0.0}[2]
            
            print("The user has selected $\(balanceEntered!) per every \(CalendarUnitHelper.convertToDateTypeString(dateType)).")
        }
    }
    
    @IBAction func yearButtonPressed(sender: AnyObject)
    {
        dayView.hidden = true
        monthView.hidden = true
        weekView.hidden = true
        yearView.hidden = false
        
        if moneyEarnedTextField.text != "$"
        {
            balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[3]] = CalendarUnitHelper.convertToFormattedDouble(moneyEarnedTextField.text!)
            
            let balanceEntered = balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[3]]
            let dateType = CalendarUnitHelper.timeUnits.map {$0.0}[3]
            
            print("The user has selected $\(balanceEntered!) per every \(CalendarUnitHelper.convertToDateTypeString(dateType)).")
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dayView.hidden = true
        monthView.hidden = true
        weekView.hidden = false
        yearView.hidden = true
        
        self.view.sendSubviewToBack(moneyImageView)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        moneyEarnedTextField.addTarget(self, action: #selector(AmountOfMoney.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        moneyEarnedTextField.tag = 100
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(detectTextFieldState), userInfo: nil, repeats: true)
        
        if testBalance != 0
        {
            moneyEarnedTextField.text = "$\(testBalance)" ?? "$"
        }
    }
    
    func detectTextFieldState()
    {
        if moneyEarnedTextField.editing == true
        {
            let desiredPosition = moneyEarnedTextField.endOfDocument
            moneyEarnedTextField.selectedTextRange = moneyEarnedTextField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
            
            textFieldDidChange(moneyEarnedTextField)
        }
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        textField.text! = textField.text!.stringByReplacingOccurrencesOfString("$", withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
        
        if !textField.text!.hasPrefix("$")
        {
            textField.text = "$" + textField.text!
        }
        
        if textField.text!.containsString(".") && !textField.text!.hasSuffix(".")
        {
            let stringArray = textField.text!.characters.split{$0 == "."}.map(String.init)
            let centsString = stringArray[1]
            
            if centsString.characters.count > 2
            {
                textField.text = textField.text!.chopSuffix(1)
            }
        }
        
        if textField.text! == "$."
        {
            textField.text! = "$"
        }
        
        let desiredPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
    }
    
    @IBAction func saveButton(sender: AnyObject)
    {
        self.view.endEditing(true)
        if moneyEarnedTextField.text != "$"
        {
            testBalance = Double(moneyEarnedTextField.text!.stringByReplacingOccurrencesOfString("$", withString: ""))!
            
            if dayView.hidden == false
            {
                timeUnit = 0
            }
            else if weekView.hidden == false
            {
                timeUnit = 1
            }
            else if monthView.hidden == false
            {
                timeUnit = 2
            }
            else
            {
                timeUnit = 3
            }
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setDouble(testBalance, forKey: "totalBalance")
            defaults.setInteger(timeUnit, forKey: "timeUnit")
            
            testBalance = defaults.doubleForKey("totalBalance")
            timeUnit = defaults.integerForKey("timeUnit")
            (self.presentingViewController?.childViewControllers[0] as! ETVC).totalBalance = testBalance
            (self.presentingViewController?.childViewControllers[0] as! ETVC).totalTimeUnit = timeUnit
            
            
            
//            print(NSUserDefaults.standardUserDefaults().integerForKey("Age"))
            
            
            (self.presentingViewController?.childViewControllers[1] as! HomeViewController).totalMoney = testBalance
            (self.presentingViewController?.childViewControllers[1] as! HomeViewController).totalTimeUnit = timeUnit
            
            //testBalance = CalendarUnitHelper.convertToBalancePerWeek(timeUnit, amountOfMoney: testBalance)
            //(self.presentingViewController?.childViewControllers[2] as! addAGoalViewController).spendingMoney = testBalance
            //(self.presentingViewController?.childViewControllers[2] as! addAGoalViewController).timeUnit = timeUnit
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {        
        if segue.identifier == "cancel"
        {
            self.dismissViewControllerAnimated(true, completion: nil)
            print("cancel button tapped")
        }
    }
}

extension AmountOfMoney : UITextFieldDelegate
{
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String) -> Bool
    {
        if textField.tag == 100
        {
            let newCharacters = NSCharacterSet(charactersInString: string)
            let boolIsNumber = NSCharacterSet.decimalDigitCharacterSet().isSupersetOfSet(newCharacters)
            
            if boolIsNumber == true
            {
                return true
            }
            else
            {
                if string == "."
                {
                    let countdots = textField.text!.componentsSeparatedByString(".").count - 1
                    if countdots == 0
                    {
                        return true
                    }
                    else
                    {
                        if countdots > 0 && string == "."
                        {
                            return false
                        }
                        else
                        {
                            return true
                        }
                    }
                }
                else
                {
                    return false
                }
            }
        }
        else
        {
            return true
        }
    }
}
