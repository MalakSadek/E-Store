//
//  SignUpBuyer2ViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/8/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class SignUpBuyer2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(row == 0) {
            return "MasterCard"
        } else  if(row == 1) {
            return "Visa"
        } else  if(row == 2) {
            return "American Express"
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0) {
            cardType = "MasterCard"
        } else  if(row == 1) {
            cardType = "Visa"
        } else  if(row == 2) {
            cardType = "American Express"
        } else {
            cardType = ""
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "buyer2ToProfile", sender: nil)
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cardNumberTextView: UITextField!
    @IBOutlet weak var securityCodeTextView: UITextField!
    @IBOutlet weak var expiryDateTextView: UITextField!
    var action:String = ""
    var cardType:String = ""
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let enteredDate = formatter.date(from: expiryDateTextView.text!)!
        let currentDate = Date()
        
        if ((cardNumberTextView.text!.isEmpty)||(securityCodeTextView.text!.isEmpty)||(expiryDateTextView.text!.isEmpty)) {
            
            let alertVC = UIAlertController(title: "Hold on a second!", message: "You need to enter all the needed information.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
            
        } else if (securityCodeTextView.text!.count > 3) {
            
            let alertVC = UIAlertController(title: "Hold on a second!", message: "You seem to have entered an invalid security code.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
            
        } else if (enteredDate < currentDate) {
            
            let alertVC = UIAlertController(title: "Hold on a second!", message: "Your card seems to have already expired, please check the entered date.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
        
            let queryItems = [NSURLQueryItem(name: "type", value: cardType), NSURLQueryItem(name: "card", value: cardNumberTextView.text), NSURLQueryItem(name: "date", value: expiryDateTextView.text), NSURLQueryItem(name: "email", value: UserDefaults.standard.string(forKey: "Email")!), NSURLQueryItem(name: "code", value: securityCodeTextView.text)]
            
            let urlComps = NSURLComponents(string: "http://malaksadekapps.com/DBAddUserBuyer2.php?")!
            
            urlComps.queryItems = queryItems as [URLQueryItem]
            
            let url = urlComps.url!
            
            let dataOfURL = NSData(contentsOf: url as URL)
            
            if (dataOfURL != nil) {
                let userDefaults = UserDefaults.standard
                userDefaults.set(cardNumberTextView.text, forKey: "CardNumber")
                userDefaults.set(securityCodeTextView.text, forKey: "SecurityCode")
                userDefaults.set(expiryDateTextView.text, forKey: "ExpiryDate")
                userDefaults.set(cardType, forKey: "CardType")
                userDefaults.set(true, forKey: "Buyer")
                
                performSegue(withIdentifier: "buyer2ToMenu", sender: nil)
            } else {
                
                let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (action == "edit") {
            backButton.isHidden = false
        } else {
            backButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
