//
//  SetAGoalViewController.swift
//  Gimme Dough
//
//  Created by Miriam Hendler on 7/12/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

class SetAGoalViewController: UIViewController
{
    //--------------------------------------------------//
    
    //Interface Builder User Interface Elements
    
    //UIButtons
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    //UITextFields
    @IBOutlet weak var nameOfGoalTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    //UIPickerViews
    @IBOutlet weak var timeForGoalPickerView: UIPickerView!
    @IBOutlet weak var sendingPickerVIew: UIPickerView!
    
    //Other Items
    @IBOutlet weak var originalSpendingMoneyLabel: UILabel!
    @IBOutlet weak var amountForSpendingTextField: UITextView!
    
    //--------------------------------------------------//
    
    //Non-Interface Builder Objects
    
    //Objects
    var timeUnitOfMoney = 4
    var spendingMoney: Double = 0
    var goalPrice: Double = 0
    var mySpendingMoney: Double = 0
    var day: Double = 1
    var week: Double = 7
    var month:Double = 28
    var year: Double = 365
    var myGoal: Double = 6
    var myDate : Double = 1
    var newSpendingMoney: Double = 0
    var savingAmount : Double = 0
    var pickerSendingMOney: Double = 10
    var imageView: UIImageView?
    var timeUnits = ["daily", "weekly", "monthly"]
    var timeForGoals = ["1 Week", "2 Weeks", "3 Weeks", "1 Month", "2 Months", "3 Months", "4 Months", "5 Months", "6 Months", "7 Months", "8 Months", "9 Months", "10 Months", "11 Months", "1 Year", "2 Years"]
    
    
    //Button Actions
    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
        
    }
    
    @IBAction func imageButtonPressed(sender: AnyObject) {
        
        //        let picker = UIImagePickerController()
        //        picker.delegate = self
        //        picker.allowsEditing = false
        //        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
        //            picker.sourceType = UIImagePickerControllerSourceType.Camera
        //        } else {
        //            pic
        //        }
        //        imageButton.setBackgroundImage(imageView?.image, forState: UIControlState.Normal)
    }
    
    //Exit Action
    @IBAction func unwindToListNotesViewController(segue: UIStoryboardSegue) {
        
    }
    
    //--------------------------------------------------//
    
    //Override Functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Dismiss Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetAGoalViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Setting up the delegates
        nameOfGoalTextField.delegate = self
        amountTextField.delegate = self
        
        //Hiding the outlets that tell you hoq much you have to save becuase no information is given yet
        amountForSpendingTextField.hidden = true
        sendingPickerVIew.hidden = true
        
        //Format the text of *amountForSpendingTextField*
        amountForSpendingTextField.text = "You can spend $\((spendingMoney))               to reach your goal"
        amountForSpendingTextField.textColor = UIColor.whiteColor()
        amountForSpendingTextField.textAlignment = .Center
        amountForSpendingTextField.font = UIFont(name: "Avenir-Book", size: 15.0)!
        
        //Format the text of *originalSpendingMoneyLabel*.
        originalSpendingMoneyLabel.textColor = UIColor.whiteColor()
        originalSpendingMoneyLabel.textAlignment = .Center
        originalSpendingMoneyLabel.font = UIFont(name: "Avenir-Book", size: 15.0)!
        sendingPickerVIew.selectRow(1, inComponent: 0, animated: true)
        
        //        if timeUnitOfMoney == 0 {
        //
        //            originalSpendingMoneyLabel.text = "You have $\(spendingMoney) of spending money per day"
        //            timeForGoalPickerView.showsSelectionIndicator = false
        //
        //            sendingPickerVIew.selectRow(0, inComponent: 0, animated: true)
        //
        //            mySpendingMoney = spendingMoney
        //        } else if timeUnitOfMoney == 1 {
        //
        //            originalSpendingMoneyLabel.text = "You have $\(spendingMoney/7) of spending money per day"
        //            mySpendingMoney = spendingMoney/7
        //        } else if timeUnitOfMoney == 2{
        //            originalSpendingMoneyLabel.text = "You have $\((spendingMoney/4)/7) of spending money per day"
        //
        //            mySpendingMoney = (spendingMoney/4)/7
        //            timeForGoalPickerView.selectRow(2, inComponent: 0, animated: true)
        //
        //        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Hiding the lines on the picker views
        sendingPickerVIew.subviews[1].hidden = true
        sendingPickerVIew.subviews[2].hidden = true
        timeForGoalPickerView.subviews[1].hidden = true
        timeForGoalPickerView.subviews[2].hidden = true
    }
    
    //Dismiss Keyboard Function
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

//MARK: Picker View Delegate

extension SetAGoalViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        if pickerView == sendingPickerVIew
        {
            return NSAttributedString(string: timeUnits[row])
        }
        else if pickerView == timeForGoalPickerView
        {
            return NSAttributedString(string: timeForGoals[row])
        }
        else
        {
            return NSAttributedString(string: "yo")
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        let titleData: String
        
        if pickerView == sendingPickerVIew
        {
            titleData = timeUnits[row]
        }
        else if pickerView == timeForGoalPickerView
        {
            titleData = timeForGoals[row]
        }
        else
        {
            titleData = "yo"
        }
        
        //Format the text of *sendingPickerVIew* and *timeForGoalPickerView*
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 15.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .Center
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == sendingPickerVIew
        {
            return timeUnits.count
        }
        else if pickerView == timeForGoalPickerView
        {
            return timeForGoals.count
        }
        else
        {
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == sendingPickerVIew
        {
            switch timeUnits[row]
            {
            case timeUnits[0]:
                amountForSpendingTextField.text = "You can spend $\(pickerSendingMOney)               to reach your goal"
//                amountForSpendingTextField.textColor = UIColor.whiteColor()
//                amountForSpendingTextField.font = UIFont(name: "Solomon-Light", size: 15.0)!
//                amountForSpendingTextField.textAlignment = .Center
                
            case timeUnits[1]:
                amountForSpendingTextField.text = "You can spend $\(pickerSendingMOney*4)               to reach your goal"
//                amountForSpendingTextField.textColor = UIColor.whiteColor()
//                amountForSpendingTextField.font = UIFont(name: "Solomon-Light", size: 15.0)!
//                amountForSpendingTextField.textAlignment = .Center
            case timeUnits[2]:
                amountForSpendingTextField.text = "You can spend $\((pickerSendingMOney*4)*7)               to reach your goal"
//                amountForSpendingTextField.textColor = UIColor.whiteColor()
//                amountForSpendingTextField.font = UIFont(name: "Solomon-Light", size: 15.0)!
//                amountForSpendingTextField.textAlignment = .Center
                
            default:
                break;
            }
            amountForSpendingTextField.textColor = UIColor.whiteColor()
            amountForSpendingTextField.font = UIFont(name: "Avenir-Book", size: 15.0)!
            amountForSpendingTextField.textAlignment = .Center
            
        }
        
//        amountForSpendingTextField.textColor = UIColor.whiteColor()
//        amountForSpendingTextField.font = UIFont(name: "Solomon-Light", size: 15.0)!
//        amountForSpendingTextField.textAlignment = .Center
//    
        else if pickerView == timeForGoalPickerView
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
            
            if amountTextField.text != "$"
            {
                myGoal = CalendarUnitHelper.convertToFormattedDouble(amountTextField.text!)
                
                let newSpendingMoney: Double = ((mySpendingMoney * myDate) - myGoal ) / myDate
                
                amountForSpendingTextField.hidden = false
                sendingPickerVIew.hidden = false
                
                amountForSpendingTextField.text = "You can spend $\(newSpendingMoney)               to reach your goal"
                amountForSpendingTextField.textColor = UIColor.whiteColor()
                amountForSpendingTextField.font = UIFont(name: "Avenir-Book", size: 15.0)!
                amountForSpendingTextField.textAlignment = .Center
                
                pickerSendingMOney = newSpendingMoney
            }
        }
    }
}

//MARK: Text Field Delegate

extension SetAGoalViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == nameOfGoalTextField
        {
            textField.text = ""
        }
        else
        {
            textField.text = "$"
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == nameOfGoalTextField
        {
            if string == "\n"
            {
                amountTextField.becomeFirstResponder()
            }
        }
        else if textField == amountTextField
        {
            if string == "\n"
            {
                amountTextField.resignFirstResponder()
            }
        }
        
        return true
    }
}

//MARK: - Image picker delegate

extension SetAGoalViewController: UIImagePickerControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            else
        {
            print("info did not have the required UIImage for the original image")
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        imageView?.image = image
    }
}
