//
//  CreateAGoalViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 8/4/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

class CreateAGoalViewController: UIViewController
{
    //UITextFields
    @IBOutlet weak var nameOfGoalTextField: UITextField!
    @IBOutlet weak var GoalAmountTextField: UITextField!
    
    //Other Outlets
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var reachByPickerView: UIPickerView!
    @IBOutlet weak var saveAmountLabel: UILabel!
    
    //Other Objects
    var currentGoal: Goal!
    var timeForGoals = ["1 Week", "2 Weeks", "3 Weeks", "1 Month", "2 Months", "3 Months", "4 Months", "5 Months", "6 Months", "7 Months", "8 Months", "9 Months", "10 Months", "11 Months", "1 Year", "2 Years"]
    var myDate : Double = 1
    let day: Double = 1
    let week: Double = 7
    let month:Double = 28
    let year: Double = 365

    //IBActions
    @IBAction func doneButtonPressed(sender: AnyObject)
    {
        self.view.endEditing(true)
        let presentingViewController = (self.presentingViewController?.childViewControllers[2] as! YourGoalsViewController)
        if nameOfGoalTextField.text != "title" && GoalAmountTextField.text != "$"
        {
            let goalAmount = Double(GoalAmountTextField.text!.stringByReplacingOccurrencesOfString("$", withString: ""))!
            var t = 0.0
            let expenseArray = RealmHelper.retrieveExpense()
            let totalBalance = NSUserDefaults.standardUserDefaults().doubleForKey("totalMoney")
            for individualObject in expenseArray {
                t += individualObject.amountOfMoney
            }
            
            let spendingMoney = totalBalance - t
            let newSpendingMoney: Double = ((spendingMoney * myDate) - goalAmount ) / myDate
            let saveAmount = spendingMoney - newSpendingMoney

            if currentGoal != nil
            {
                let updateGoal = Goal()
                
                updateGoal.priceOfGoal = goalAmount
                updateGoal.goalName = nameOfGoalTextField.text!
                updateGoal.timeToReachGoal = myDate
                updateGoal.goalImage = CalendarUnitHelper.convertUIImageToNSData(goalImageView.image!)
                updateGoal.amountToSave = saveAmount
                
                RealmHelper.updateGoal(currentGoal, newGoal: updateGoal)
                
                presentingViewController.goalsTableView.reloadData()
            }
            else
            {
                let newGoal = Goal()
                newGoal.priceOfGoal = Double(GoalAmountTextField.text!.stringByReplacingOccurrencesOfString("$", withString: ""))!
                newGoal.itemTag = randomInteger(1, maximumValue: 9999)
                newGoal.goalName = nameOfGoalTextField.text!
                newGoal.goalImage = CalendarUnitHelper.convertUIImageToNSData(goalImageView.image!)
                newGoal.timeToReachGoal = myDate
                newGoal.amountToSave = saveAmount
                RealmHelper.addGoal(newGoal)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentingViewController.goalArray = RealmHelper.retrieveGoal()
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
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    //Override Functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Setting up the delegates for *reachByPickerView* and *GoalAmountTextField*
        reachByPickerView.delegate = self
        reachByPickerView.dataSource = self
        GoalAmountTextField.delegate = self
        nameOfGoalTextField.delegate = self
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //If currentExpense does indeed exist, format various items.
        if let verifiedCurrentGoal = currentGoal
        {
            //Format the text of *nameOfExpenseTextField* and *balanceTextField*.
            nameOfGoalTextField.text = verifiedCurrentGoal.goalName
            nameOfGoalTextField.textColor = UIColor.whiteColor()
            let formater = NSNumberFormatter()
            formater.numberStyle = .CurrencyStyle
            GoalAmountTextField.text = "\(formater.stringFromNumber(verifiedCurrentGoal.priceOfGoal)!)"
            saveAmountLabel.text = "\(formater.stringFromNumber(verifiedCurrentGoal.amountToSave)) /Week"
            goalImageView.image = CalendarUnitHelper.convertNSDataToUIImage(verifiedCurrentGoal.goalImage)
            
            if verifiedCurrentGoal.timeToReachGoal == week // Week
            {
                reachByPickerView.selectRow(0, inComponent: 0, animated: true)
            }
            else if  verifiedCurrentGoal.timeToReachGoal == week * 2 // 2 Weeks
            {
                reachByPickerView.selectRow(1, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == week * 3 // 3 Weeks
            {
                reachByPickerView.selectRow(2, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month // 1 Month
            {
                reachByPickerView.selectRow(3, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 2 // 2 Months
            {
                reachByPickerView.selectRow(4, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 3 // 3 Months
            {
                reachByPickerView.selectRow(5, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 4 // 4 Months
            {
                reachByPickerView.selectRow(6, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 5 // 5 Months
            {
                reachByPickerView.selectRow(7, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 6 // 6 Months
            {
                reachByPickerView.selectRow(8, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 7 // 7 Months
            {
                reachByPickerView.selectRow(9, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 8// 9 Months
            {
                reachByPickerView.selectRow(10, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 9 // 10 Months
            {
                reachByPickerView.selectRow(11, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 10 // 11 Months
            {
                reachByPickerView.selectRow(12, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 11 // 12 Months
            {
                reachByPickerView.selectRow(13, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == year // 1 Year
            {
                reachByPickerView.selectRow(14, inComponent: 0, animated: true)
            }
            else if verifiedCurrentGoal.timeToReachGoal == year * 2 // 2 Years
            {
                reachByPickerView.selectRow(15, inComponent: 0, animated: true)
            }
        }
        else
        {
            //Format various items if there does not exist a current expense.
            GoalAmountTextField.text = "$"
            nameOfGoalTextField.text = "title"
            reachByPickerView.selectRow(3, inComponent: 0, animated: true)
            
        }
        //As the balance text field edits, remove disallowed characters.
        GoalAmountTextField.addTarget(self, action: #selector(AOEC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        GoalAmountTextField.tag = 100
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(detectTextFieldState), userInfo: nil, repeats: true)
}
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

//MARK: -Picker View Delagate
extension CreateAGoalViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
       return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
      return  timeForGoals.count
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
            return NSAttributedString(string: timeForGoals[row])
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        let titleData = timeForGoals[row]

        //Format the text of *timeForGoalPickerView*
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .Center
        
        return pickerLabel
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch timeForGoals[row]
            {
            case timeForGoals[0]: // Week
                
                myDate = week
                
            case timeForGoals[1]: // 2 Weeks
                
                myDate = week * 2
                
            case timeForGoals[2]: // 3 Weeks
                
                myDate = week * 3
                
            case timeForGoals[3]: // 1 Month
                
                myDate = month
                
            case timeForGoals[4]: // 3 Months
                
                myDate = month * 2
                
            case timeForGoals[5]: // 4 Months
                
                myDate = month * 3
                
            case timeForGoals[6]: // 5 Months
                
                myDate = month * 4
                
            case timeForGoals[7]: // 6 Months
                
                myDate = month * 5
                
            case timeForGoals[8]: // 7 Months
                
                myDate = month * 6
                
            case timeForGoals[9]: // 8 Months
                
                myDate = month * 7
                
            case timeForGoals[10]: // 9 Months
                
                myDate = month * 8
                
            case timeForGoals[11]: // 10 Months
                
                myDate = month * 9
                
            case timeForGoals[12]: // 11 Months
                
                myDate = month * 10
                
            case timeForGoals[13]: // 12 Months
                
                myDate = month * 11
                
            case timeForGoals[14]: // 1 Year
                
                myDate = year
                
            case timeForGoals[15]: // 2 Years
                
                myDate = year * 2
                
            default:
                break;
            }
        
        let goalAmount = Double(GoalAmountTextField.text!.stringByReplacingOccurrencesOfString("$", withString: ""))!
        var t = 0.0
        let expenseArray = RealmHelper.retrieveExpense()
        let totalBalance = NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance")
        for individualObject in expenseArray {
            t += individualObject.amountOfMoney
        }
        let spendingMoney = totalBalance - t
        let newSpendingMoney: Double = ((spendingMoney * myDate) - goalAmount ) / myDate
        let saveAmount = spendingMoney - newSpendingMoney
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.locale = NSLocale(localeIdentifier: "es_US")
        
        saveAmountLabel.text = "\(currencyFormatter.stringFromNumber(saveAmount)!) /Week"
    }
    
    //Independent Functions
    
    func detectTextFieldState()
    {
        if GoalAmountTextField.editing == true
        {
            let desiredPosition = GoalAmountTextField.endOfDocument
            GoalAmountTextField.selectedTextRange = GoalAmountTextField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
            textFieldDidChange(GoalAmountTextField)
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

extension CreateAGoalViewController : UITextFieldDelegate
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

extension CreateAGoalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        if let verifiedCurrentGoal = currentGoal
        {
            verifiedCurrentGoal.goalImage = CalendarUnitHelper.convertUIImageToNSData(image)
        }
        else
        {
            goalImageView.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}

