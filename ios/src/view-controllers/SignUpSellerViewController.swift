//
//  SignUpSellerViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/8/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class SignUpSellerViewController: UIViewController {

    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "sellerToMenu", sender: nil)
    }

    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if ((firstNameTextView.text!.isEmpty)||(lastNameTextView.text!.isEmpty)||(passwordTextView.text!.isEmpty)||(verifyPasswordTextView.text!.isEmpty)||(emailTextView.text!.isEmpty)||(phoneTextView.text!.isEmpty)||(addressTextView.text!.isEmpty)) {
            
            let alertVC = UIAlertController(title: "Hold on a second!", message: "Please enter information in all the fields.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        } else if (passwordTextView.text != verifyPasswordTextView.text){
            
            let alertVC = UIAlertController(title: "Hold on a second!", message: "Passwords don't match, please re-enter them.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        } else if (!(emailTextView.text?.contains("@"))!) {
            let alertVC = UIAlertController(title: "Hold on a second!", message: "You seem to have entered an invalid email address.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            
            let queryItems = [NSURLQueryItem(name: "fname", value: firstNameTextView.text), NSURLQueryItem(name: "lname", value: lastNameTextView.text), NSURLQueryItem(name: "number", value: phoneTextView.text), NSURLQueryItem(name: "email", value: emailTextView.text), NSURLQueryItem(name: "password", value: passwordTextView.text), NSURLQueryItem(name: "address", value: addressTextView.text)]
            
            var urlComps:NSURLComponents
            
            if (action == "") {
                urlComps = NSURLComponents(string: "http://malaksadekapps.com/DBAddUserSeller.php?")!
            }
            else {
                urlComps = NSURLComponents(string: "http://malaksadekapps.com/DBEditUserSeller.php?")!
            }
            
            urlComps.queryItems = queryItems as [URLQueryItem]
            
            let url = urlComps.url!
            
            let dataOfURL = NSData(contentsOf: url as URL)
            
            if (dataOfURL != nil) {
                let userDefaults = UserDefaults.standard
                userDefaults.set(firstNameTextView.text, forKey: "Fname")
                userDefaults.set(lastNameTextView.text, forKey: "LName")
                userDefaults.set(phoneTextView.text, forKey: "Phone")
                userDefaults.set(passwordTextView.text, forKey: "Password")
                userDefaults.set(addressTextView.text, forKey: "Address")
                userDefaults.set(emailTextView.text, forKey: "Email")
                
                
                if (action == "") {
                    userDefaults.set(true, forKey: "First")
                    userDefaults.set(true, forKey: "Seller")
                    userDefaults.set(false, forKey: "Store")
                }
                
                performSegue(withIdentifier: "sellerToMenu", sender: nil)
            } else {
                
                let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var addressTextView: UITextField!
    @IBOutlet weak var phoneTextView: UITextField!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var verifyPasswordTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var firstNameTextView: UITextField!
    @IBOutlet weak var lastNameTextView: UITextField!
    var action:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
