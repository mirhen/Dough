//
//  AmountOfExpensesViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import RealmSwift

class AOEC: UIViewController
{
    //--------------------------------------------------//
    
    //Interface Builder User Interface Elements
    
    //UITextFields
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var nameOfExpenseTextField: UITextField!
    
    //UIViews
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var yearView: UIView!
    
    //Other Outlets
    @IBOutlet weak var expenseImageView: UIImageView!
    
    //--------------------------------------------------//
    
    //Non-Interface Builder Objects
    
    //Other Objects
    var balanceDictionary: [Int : Double] = [:]
    var currentExpense: Expense?
    var newImage: UIImage?
    
    //Action Objects
    @IBAction func dayButtonPressed(sender: AnyObject)
    {
        dayView.hidden = false
        monthView.hidden = true
        weekView.hidden = true
        yearView.hidden = true
        
        if balanceTextField.text != "$"
        {
            balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[0]] = CalendarUnitHelper.convertToFormattedDouble(balanceTextField.text!)
            
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
        
        if balanceTextField.text != "$"
        {
            balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[1]] = CalendarUnitHelper.convertToFormattedDouble(balanceTextField.text!)
            
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
        
        if balanceTextField.text != "$"
        {
            balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[2]] = CalendarUnitHelper.convertToFormattedDouble(balanceTextField.text!)
            
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
        
        if balanceTextField.text != "$"
        {
            balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[3]] = CalendarUnitHelper.convertToFormattedDouble(balanceTextField.text!)
            
            let balanceEntered = balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[3]]
            let dateType = CalendarUnitHelper.timeUnits.map {$0.0}[3]
            
            print("The user has selected $\(balanceEntered!) per every \(CalendarUnitHelper.convertToDateTypeString(dateType)).")
        }
    }
    
    @IBAction func takePhotoButtonPressed(sender: AnyObject)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose A Photo", preferredStyle: .ActionSheet)
        
        // 2
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
                {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                    imagePicker.allowsEditing = false
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                
                print("taking a photo")
        })
        let choosePhotoAction = UIAlertAction(title: "Choose From Library", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
                {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                    imagePicker.allowsEditing = true
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                
                print("choosing a photo from the library")
        })
        //        let googlePhotoAction = UIAlertAction(title: "Google", style: .Default, handler: {
        //            (alert: UIAlertAction!) -> Void in
        //            print("googling a photo")
        //        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
        })
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(choosePhotoAction)
        //        optionMenu.addAction(googlePhotoAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    //--------------------------------------------------//
    
    //Override Functions
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //If currentExpense does indeed exist, format various items.
        if let verifiedCurrentExpense = currentExpense
        {
           // newImage = verifiedCurrentExpense.expenseImage
            
            //Format the text of *nameOfExpenseTextField* and *balanceTextField*.
            nameOfExpenseTextField.text = verifiedCurrentExpense.expenseName
            nameOfExpenseTextField.textColor = UIColor.whiteColor()
            balanceTextField.text = "$\(verifiedCurrentExpense.amountOfMoney)"
           expenseImageView.image = CalendarUnitHelper.convertNSDataToUIImage(verifiedCurrentExpense.expenseImage)
            
            //For each type of date chosen, select the appropriate row in the date type picker view.
            if verifiedCurrentExpense.timeUnit == 0
            {
                //Hiding unselected time units
                dayView.hidden = false
                monthView.hidden = true
                weekView.hidden = true
                yearView.hidden = true
            }
            else if verifiedCurrentExpense.timeUnit == 1
            {
                dayView.hidden = true
                monthView.hidden = true
                weekView.hidden = false
                yearView.hidden = true
            }
            else if verifiedCurrentExpense.timeUnit == 2
            {
                dayView.hidden = true
                monthView.hidden = false
                weekView.hidden = true
                yearView.hidden = true
            }
            else if verifiedCurrentExpense.timeUnit == 3
            {
                dayView.hidden = true
                monthView.hidden = true
                weekView.hidden = true
                yearView.hidden = false
            }
        }
        else
        {
            //Format various items if there does not exist a current expense.
            balanceTextField.text = "$"
            nameOfExpenseTextField.text = "title"
                
            //Hiding unselected time units
            dayView.hidden = false
            monthView.hidden = true
            weekView.hidden = true
            yearView.hidden = true
            
        }
        
        //As the balance text field edits, remove disallowed characters.
        balanceTextField.addTarget(self, action: #selector(AOEC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        balanceTextField.tag = 100
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(detectTextFieldState), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //setting the delegates
        nameOfExpenseTextField.delegate = self
        
        //Set the amount of all money to _____.
        balanceDictionary[CalendarUnitHelper.timeUnits.map {$0.0}[0]] = 0
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                expenseImageView.translatesAutoresizingMaskIntoConstraints = false
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        print("prepareForSegue")
        
        if segue.identifier == "cancelEditSegue"
        {
            print("cancel button tapped")
        }
    }
    
    //--------------------------------------------------//
    
    //Interface Builder Actions
    
    @IBAction func saveButton(sender: AnyObject)
    {
        self.view.endEditing(true)
        let presentingViewController = (self.presentingViewController?.childViewControllers[0] as! ETVC)
        

        if balanceTextField.text != "$"
        {
            if currentExpense != nil
            {
                var timeUnit = 4
                
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

                let newExpense = Expense()
                newExpense.amountOfMoney = Double(balanceTextField.text!.stringByReplacingOccurrencesOfString("$", withString: ""))!
                newExpense.expenseName = nameOfExpenseTextField.text!
                newExpense.timeUnit = timeUnit
                newExpense.expenseImage = CalendarUnitHelper.convertUIImageToNSData(expenseImageView.image!)
                RealmHelper.updateExpense(currentExpense!, newExpense: newExpense)
                presentingViewController.amountTableView.reloadData()
            }
            else
            {
                var timeUnit = 4
                
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
                let newExpense = Expense()
                newExpense.amountOfMoney = balanceDictionary[0]!
                newExpense.itemTag = randomInteger(1, maximumValue: 9999)
                newExpense.timeUnit = timeUnit
                newExpense.expenseImage = CalendarUnitHelper.convertUIImageToNSData(expenseImageView.image!)
                RealmHelper.addExpense(newExpense)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentingViewController.expenseArray = RealmHelper.retrieveExpense()
    }
    
    //--------------------------------------------------//
    
    //Independent Functions
    
    func detectTextFieldState()
    {
        if balanceTextField.editing == true
        {
            let desiredPosition = balanceTextField.endOfDocument
            balanceTextField.selectedTextRange = balanceTextField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
            
            textFieldDidChange(balanceTextField)
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
}

extension AOEC : UITextFieldDelegate
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "title"
        {
            textField.text = ""
        }
    }
}
extension AOEC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        if let verifiedCurrentExpense = currentExpense
        {
            verifiedCurrentExpense.expenseImage = CalendarUnitHelper.convertUIImageToNSData(image)
        }
        else
        {
            expenseImageView.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
