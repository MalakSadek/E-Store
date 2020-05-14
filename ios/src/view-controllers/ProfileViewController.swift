//
//  ProfileViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/8/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var cartDictionary:NSDictionary = [:]
    var storeName:String = ""
    var categories:String = ""
    var arrayOfnames:[String] = []
    var arrayOfprices:[String] = []
    var arrayOfquantities:[String] = []
    var arrayOfDescriptions:[String] = []
    var arrayOfOprices:[String] = []
    var arrayOfstatuses:[String] = []
    var arrayOfBuyers:[String] = []
    var arrayOfproductNumbers:[String] = []
    var cdata:NSArray = []
    
    @IBAction func logoutButtonPressed(_ sender: Any) {

        let alertVC = UIAlertController(title: "Gone so soon?", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "No", style: .default, handler: nil)
        
        let alertActionLogout = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "First")
            userDefaults.set("None", forKey: "Email")
            userDefaults.set("None", forKey: "Password")
            userDefaults.set(false, forKey: "Buyer")
            userDefaults.set(false, forKey: "Seller")
            userDefaults.set(false, forKey: "Store")
            self.performSegue(withIdentifier: "profileToFirst", sender: nil)
        }
        
        alertVC.addAction(alertActionLogout)
        alertVC.addAction(alertActionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func editInfoButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "editInfo", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "profileToMenu", sender: nil)
    }
    
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var securityCodeLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var registerBuyerButton: UIButton!
    @IBOutlet weak var registerSeller: UIButton!
    @IBOutlet weak var viewStoreButton: UIButton!
    @IBOutlet weak var setupStoreButton: UIButton!
    @IBOutlet weak var editPaymentInfoButton: UIButton!
    
    @IBOutlet weak var cardTypeText: UILabel!
    @IBOutlet weak var cardNumberText: UILabel!
    @IBOutlet weak var securityCodeText: UILabel!
    @IBOutlet weak var expiryDateText: UILabel!
    
    @IBAction func viewStoreButtonPressed(_ sender: Any) {
        
        let url1 = NSURL(string: "http://malaksadekapps.com/DBStoreInfo.php?email="+UserDefaults.standard.string(forKey: "Email")!)
        
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
            cartDictionary = cdata[0] as! NSDictionary
            storeName = cartDictionary["storeName"] as! String
            categories = cartDictionary["Categories"] as! String
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
        
        
        let url2 = NSURL(string: "http://malaksadekapps.com/DBOrderInfo.php?email="+UserDefaults.standard.string(forKey: "Email")!)
        
        let dataOfURL2 = NSData(contentsOf: url2! as URL)
        
        do {
            if (dataOfURL2 != nil) {
                cdata = try JSONSerialization.jsonObject(with: dataOfURL2! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            }
        } catch {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
        
        if (cdata.count != 0) {
            
            for i in 0..<cdata.count{
                cartDictionary = cdata[i] as! NSDictionary
                if (cartDictionary["OrderID"] as! String != "null") {
                    arrayOfOprices.append(cartDictionary["OrderID"] as! String)
                    arrayOfstatuses.append(cartDictionary["Status"] as! String)
                    arrayOfBuyers.append(cartDictionary["Buyer"] as! String)
                }
            }
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
        
        let url3 = NSURL(string: "http://malaksadekapps.com/DBProductInfo.php?email="+UserDefaults.standard.string(forKey: "Email")!)
        
        let dataOfURL3 = NSData(contentsOf: url3! as URL)
        
        do {
            if (dataOfURL3 != nil) {
                cdata = try JSONSerialization.jsonObject(with: dataOfURL3! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            }
        } catch {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
        
        if (cdata.count != 0) {
            
            for i in 0..<cdata.count{
                
                cartDictionary = cdata[i] as! NSDictionary
                if (cartDictionary["ProductName"] as! String != "null") {
                    arrayOfnames.append(cartDictionary["ProductName"] as! String)
                    arrayOfprices.append(cartDictionary["ProductPrice"] as! String)
                    arrayOfproductNumbers.append(cartDictionary["ProductNumber"] as! String)
                    arrayOfquantities.append(cartDictionary["ProductStock"] as! String)
                    arrayOfDescriptions.append(cartDictionary["ProductDescription"] as! String)
                }
            }
            
            performSegue(withIdentifier: "profileToStore", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func setupStoreButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "setupStore", sender: nil)
    }
    @IBAction func registerAsSellerButtonPressed(_ sender: Any) {
        
        let url1 = NSURL(string: "http://malaksadekapps.com/DBRegisterSeller.php?email="+UserDefaults.standard.string(forKey: "Email")!)
        
        let dataOfURL1 = NSData(contentsOf: url1! as URL)
        
        if (dataOfURL1 != nil) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "Seller")
            registerSeller.isHidden = true
            setupStoreButton.isHidden = false
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    @IBAction func registerAsBuyerButtonPressed(_ sender: Any) {
        
        let url1 = NSURL(string: "http://malaksadekapps.com/DBRegisterBuyer.php?email="+UserDefaults.standard.string(forKey: "Email")!)
        
        let dataOfURL1 = NSData(contentsOf: url1! as URL)
        
        if (dataOfURL1 != nil) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "Buyer")
            performSegue(withIdentifier: "registerBuyer", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
    
    }
    @IBAction func editPaymentInfoButtonPressed(_ sender: Any) {
         performSegue(withIdentifier: "editPInfo", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        
        firstNameLabel.text = userDefaults.string(forKey: "Fname")
        lastNameLabel.text = userDefaults.string(forKey: "LName")
        emailLabel.text = userDefaults.string(forKey: "Email")
        phoneLabel.text = userDefaults.string(forKey: "Phone")
        addressLabel.text = userDefaults.string(forKey: "Address")
        
        registerSeller.isHidden = true
        viewStoreButton.isHidden = true
        setupStoreButton.isHidden = true
        cardTypeText.isHidden = true
        cardTypeLabel.isHidden = true
        cardNumberText.isHidden = true
        cardNumberLabel.isHidden = true
        securityCodeText.isHidden = true
        securityCodeLabel.isHidden = true
        expiryDateText.isHidden = true
        expiryDateLabel.isHidden = true
        editPaymentInfoButton.isHidden = true
        registerBuyerButton.isHidden = true
        
        if(userDefaults.bool(forKey: "Seller")) {
            if(userDefaults.bool(forKey: "Store")) {
                viewStoreButton.isHidden = false
            } else {
                setupStoreButton.isHidden = false
            }
        } else {
            registerSeller.isHidden = false
        }
        
        if(userDefaults.bool(forKey: "Buyer")) {
            cardTypeText.isHidden = false
            cardTypeLabel.isHidden = false
            cardNumberText.isHidden = false
            cardNumberLabel.isHidden = false
            securityCodeText.isHidden = false
            securityCodeLabel.isHidden = false
            expiryDateText.isHidden = false
            expiryDateLabel.isHidden = false
            editPaymentInfoButton.isHidden = false
            
            cardNumberLabel.text = userDefaults.string(forKey: "CardNumber")
            cardTypeLabel.text = userDefaults.string(forKey: "CardType")
            securityCodeLabel.text = userDefaults.string(forKey: "SecurityCode")
            expiryDateLabel.text = userDefaults.string(forKey: "ExpiryDate")
        } else {
            registerBuyerButton.isHidden = false
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editInfo"){
            let destVC: SignUpSellerViewController = segue.destination as! SignUpSellerViewController
            //sends array of names and images to table
            destVC.action = "edit"
        }
        if(segue.identifier == "setupStore"){
            let destVC: SetupStoreViewController = segue.destination as! SetupStoreViewController
            //sends array of names and images to table
            destVC.source = "setup"
        }
        if(segue.identifier == "editPInfo"){
            let destVC: SignUpBuyer2ViewController = segue.destination as! SignUpBuyer2ViewController
            //sends array of names and images to table
            destVC.action = "edit"
        }
        if(segue.identifier == "profileToStore") {
            let destVC: MyStoreViewController = segue.destination as! MyStoreViewController
            destVC.storeName = self.storeName
            destVC.storeCats = self.categories
            destVC.productName = self.arrayOfnames
            destVC.productPrice = self.arrayOfprices
            destVC.productStock = self.arrayOfquantities
            destVC.productDescription = self.arrayOfDescriptions
            destVC.orderPrice = self.arrayOfOprices
            destVC.orderStatus = self.arrayOfstatuses
            destVC.orderEmail = self.arrayOfBuyers
            destVC.arrayOfproductNumbers = self.arrayOfproductNumbers
        }
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
