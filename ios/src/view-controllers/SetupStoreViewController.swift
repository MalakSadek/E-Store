//
//  SetupStoreViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/8/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class SetupStoreViewController: UIViewController {

    var source:String = ""
    var url:NSURL = NSURL(string: "")!
    var categories:String = ""
    
    @IBOutlet weak var storeNameTextField: UITextField!
    
    @IBOutlet weak var foodSwitch: UISwitch!
    @IBOutlet weak var electronicsSwitch: UISwitch!
    @IBOutlet weak var homeSwitch: UISwitch!
    @IBOutlet weak var stationarySwitch: UISwitch!
    @IBOutlet weak var sportsSwitch: UISwitch!
    @IBOutlet weak var accessoriesSwitch: UISwitch!
    @IBOutlet weak var fashionSwitch: UISwitch!
    
    var cartDictionary:NSDictionary = [:]
    var storeName:String = ""
    var arrayOfnames:[String] = []
    var arrayOfprices:[String] = []
    var arrayOfquantities:[String] = []
    var arrayOfDescriptions:[String] = []
    var arrayOfOprices:[String] = []
    var arrayOfstatuses:[String] = []
    var arrayOfBuyers:[String] = []
    var arrayOfproductNumbers:[String] = []
    var cdata:NSArray = []
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if (storeNameTextField.text!.isEmpty) {
            
            let alertVC = UIAlertController(title: "Please enter a store name!", message: "If you're editing your store: enter the store name even if it's the same as the old name.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
            
        } else if ((!foodSwitch.isOn)&&(!electronicsSwitch.isOn)&&(!homeSwitch.isOn)&&(!stationarySwitch.isOn)&&(!sportsSwitch.isOn)&&(!accessoriesSwitch.isOn)&&(!fashionSwitch.isOn)) {
            
            let alertVC = UIAlertController(title: "Please select a category!", message: "You have to choose at least one, choose the one that applies the most.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            
            categories = ""
            
            if(fashionSwitch.isOn) {
                categories = categories + "Fashion, ";
            }
            if(homeSwitch.isOn) {
                categories = categories + "Home & Furniture, ";
            }
            if(foodSwitch.isOn) {
                categories = categories + "Food & Beverages, ";
            }
            if(accessoriesSwitch.isOn) {
                categories = categories + "Accessories, ";
            }
            if(electronicsSwitch.isOn) {
                categories = categories + "Electronics, ";
            }
            if(sportsSwitch.isOn) {
                categories = categories + "Sports, ";
            }
            if(stationarySwitch.isOn) {
                categories = categories + "Stationary, ";
            }
            
            categories = String(categories.dropLast())
            categories = String(categories.dropLast())
            
            let IP = UserDefaults.standard.string(forKey: "IP")!
            
            let queryItems = [NSURLQueryItem(name: "storename", value: storeNameTextField.text), NSURLQueryItem(name: "categories", value: categories), NSURLQueryItem(name:"email", value: UserDefaults.standard.string(forKey: "Email")!)]
            
            var urlComps:NSURLComponents
            
            if (source == "setup") {
                urlComps = NSURLComponents(string: "http://malaksadekapps.com/DBSetupStore.php?")!
            } else if (source == "edit"){
                urlComps = NSURLComponents(string: "http://malaksadekapps.com/DBEditStore.php?")!
            } else {
                urlComps = NSURLComponents(string: "")!
            }
            
            urlComps.queryItems = queryItems as [URLQueryItem]
            
            let url = urlComps.url!
            
            let dataOfURL = NSData(contentsOf: url as URL)
            
            if (dataOfURL != nil) {
                
                let url1 = NSURL(string: "http://malaksadekapps/DBStoreInfo.php?email="+UserDefaults.standard.string(forKey: "Email")!)
                
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
                    
                    performSegue(withIdentifier: "setupToStore", sender: nil)
                } else {
                    
                    let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
                    
                    let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
                }
                
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "setupToStore") {
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
