//
//  LoginViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/7/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var cdata:NSArray = []
    var dictionaryOfData:NSDictionary = [:]
    var dictionaryOfData1:NSDictionary = [:]
    var dictionaryOfData2:NSDictionary = [:]
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginToFirst", sender: nil)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
       
        if (emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty) {
            
            let alertVC = UIAlertController(title: "Hold on a second!", message: "You need to enter both an email and a password.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)

            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        } else
        if (!(emailTextField.text?.contains("@"))!) {
            
            let alertVC = UIAlertController(title: "Hold on a second!", message: "You seem to have entered an invalid email address.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        } else {
   
            
            let url1 = NSURL(string: "http://malaksadekapps.com/DBUserLogin.php?email="+emailTextField.text!)
            
            let dataOfURL1 = NSData(contentsOf: url1! as URL)
            
            do {
                if (dataOfURL1 != nil) {
                    cdata = try JSONSerialization.jsonObject(with: dataOfURL1! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                }
            } catch {
                
                   let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
            }
            
            if (cdata.count != 0) {
                 let userDefaults = UserDefaults.standard
                
                    dictionaryOfData = cdata[0] as! NSDictionary
                    dictionaryOfData1 = cdata[1] as! NSDictionary
                    dictionaryOfData2 = cdata[2] as! NSDictionary
                
                    userDefaults.set(dictionaryOfData["FName"] as! String, forKey: "Fname")
                    userDefaults.set(dictionaryOfData["LName"] as! String, forKey: "LName")
                    userDefaults.set(emailTextField.text!, forKey: "Email")
                    userDefaults.set(dictionaryOfData["Address"] as! String, forKey: "Address")
                    userDefaults.set(dictionaryOfData["Phone"] as! String, forKey: "Phone")
                    userDefaults.set(dictionaryOfData["Password"] as! String, forKey: "Password")
                    userDefaults.set(true, forKey: "First")
                
                    if(dictionaryOfData["SellerNum"] as! String == "null") {
                        userDefaults.set(false, forKey: "Seller")
                    } else {
                        userDefaults.set(true, forKey: "Seller")
                        if ((dictionaryOfData1["StoreName"] as! String).isEmpty) {
                            userDefaults.set(false, forKey: "Store")
                        } else {
                            userDefaults.set(true, forKey: "Store")
                        }
                    }
                
                    if(dictionaryOfData["BuyerNum"] as! String == "null") {
                        userDefaults.set(false, forKey: "Buyer")
                    } else {
                        userDefaults.set(true, forKey: "Buyer")
                        userDefaults.set(dictionaryOfData2["Card"] as! String, forKey: "CardNumber")
                        userDefaults.set(dictionaryOfData2["SecurityCode"] as! String, forKey: "SecurityCode")
                        userDefaults.set(dictionaryOfData2["ExpiryDate"] as! String, forKey: "ExpiryDate")
                        userDefaults.set(dictionaryOfData2["cardType"] as! String, forKey: "CardType")
                    }
                
                    performSegue(withIdentifier: "loginToMenu", sender: nil)
            } else {
                
                let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
