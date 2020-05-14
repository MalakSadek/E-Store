//
//  MenuViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/7/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var cartDictionary:NSDictionary = [:]
    var arrayOfnames:[String] = []
    var arrayOfCategories:[String] = []
    var arrayOfprices:[String] = []
    var arrayOfOprices:[String] = []
    var arrayOfquantities:[String] = []
    var arrayOfproductNumbers:[String] = []
    var arrayOfstatuses:[String] = []
    var arrayOfBuyers:[String] = []
    var arrayOfDescriptions:[String] = []
    var total:String = ""
    var storeName:String = ""
    var categories:String = ""
    var cdata:NSArray = []
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var myCartButton: UIButton!
    
    @IBOutlet weak var myOrdersButton: UIButton!
    
    @IBOutlet weak var myStoreButton: UIButton!
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        let url1 = NSURL(string: "http://malaksadekapps.com/DBFillStores.php")
        
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
            
            for i in 0..<cdata.count{
                
                cartDictionary = cdata[i] as! NSDictionary
                if let title = cartDictionary["storeName"]
                {
                    arrayOfnames.append(cartDictionary["storeName"] as! String)
                    arrayOfCategories.append(cartDictionary["storeCat"] as! String)
                }
            }
            
            performSegue(withIdentifier: "menuToSearch", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "menuToProfile", sender: nil)
    }
    
    @IBAction func myCartButtonPressed(_ sender: Any) {
        
        let url1 = NSURL(string: "http://malaksadekapps.com/DBFillCart.php?email="+UserDefaults.standard.string(forKey: "Email")!)
        
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
            
            if (cartDictionary["Total"] as? String) != nil
            {
                self.total = cartDictionary["Total"] as! String
            }
            else {
                self.total = "0"
            }
            
            for i in 1..<cdata.count{
                
                cartDictionary = cdata[i] as! NSDictionary
                arrayOfnames.append(cartDictionary["ProductName"] as! String)
                arrayOfprices.append(cartDictionary["ProductPrice"] as! String)
                arrayOfquantities.append(cartDictionary["ProductStock"] as! String)
                arrayOfproductNumbers.append(cartDictionary["ProductNumber"] as! String)
            }
            
            performSegue(withIdentifier: "menuToCart", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func myOrdersButtonPressed(_ sender: Any) {
        
        let url1 = NSURL(string: "http://malaksadekapps.com/DBFillOrder.php?email="+UserDefaults.standard.string(forKey: "Email")!)
        
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
            
            for i in 0..<cdata.count{
                cartDictionary = cdata[i] as! NSDictionary
                if (cartDictionary["OrderID"] as! String != "null")
                {
                    arrayOfnames.append(cartDictionary["Product"] as! String)
                    arrayOfprices.append(cartDictionary["Status"] as! String)
                    arrayOfquantities.append(cartDictionary["Quantity"] as! String)
                    arrayOfproductNumbers.append(cartDictionary["OrderID"] as! String)
                }
                
            }
            
            performSegue(withIdentifier: "menuToOrders", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func myStoreButtonPressed(_ sender: Any) {
        
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
            
            performSegue(withIdentifier: "menuToStore", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.standard
        if(!userDefaults.bool(forKey: "Seller")) {
            myStoreButton.setTitleColor(.red, for: .normal)
            myStoreButton.isEnabled = false
        }
        if(!userDefaults.bool(forKey: "Buyer")) {
            searchButton.setTitleColor(.red, for: .normal)
            searchButton.isEnabled = false
            myOrdersButton.setTitleColor(.red, for: .normal)
            myOrdersButton.isEnabled = false
            myCartButton.setTitleColor(.red, for: .normal)
            myCartButton.isEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "menuToCart"){
            let destVC: MyCartViewController = segue.destination as! MyCartViewController
            //sends array of names and images to table
            destVC.arrayOfnames = self.arrayOfnames
            destVC.arrayOfprices = self.arrayOfprices
            destVC.arrayOfquantities = self.arrayOfquantities
            destVC.arrayOfproductNumbers = self.arrayOfproductNumbers
            destVC.total = self.total
        }
        
        if(segue.identifier == "menuToOrders") {
            let destVC: MyOrdersViewController = segue.destination as! MyOrdersViewController
            destVC.arrayOfnames = self.arrayOfnames
            destVC.arrayOfstatuses = self.arrayOfprices
            destVC.arrayOfquantities = self.arrayOfquantities
            destVC.arrayOforderIDs = self.arrayOfproductNumbers
        }
        
        if(segue.identifier == "menuToStore") {
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
        
        if(segue.identifier == "menuToSearch") {
            let destVC: SearchViewController = segue.destination as! SearchViewController
            destVC.arrayOfnames = self.arrayOfnames
            destVC.arrayOfCategories = self.arrayOfCategories
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
