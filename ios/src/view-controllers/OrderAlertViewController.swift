//
//  OrderAlertViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/12/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class OrderAlertViewController: UIViewController {
  
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var price:String = ""
    var status:String = ""
    var email:String = ""
    var name:String = ""
    var desc:String = ""
    var stock:String = ""
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
    var type = ""
    var index = ""
    var cdata:NSArray = []
    
    @IBOutlet weak var statusTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = price
        statusLabel.text = status
        emailLabel.text = email
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateStatusButtonPressed(_ sender: Any) {
 
        let queryItems = [NSURLQueryItem(name: "Status", value: statusTextField.text!), NSURLQueryItem(name: "Email", value: UserDefaults.standard.string(forKey: "Email")!)]
        
        let urlComps = NSURLComponents(string: "http://malaksadekapps.com/DBEditOrder.php?")!
        
        urlComps.queryItems = queryItems as [URLQueryItem]
        
        let url = urlComps.url!
        
        let dataOfURL = NSData(contentsOf: url as URL)
        
        if (dataOfURL != nil) {
            priceLabel.text = price
            statusLabel.text = statusTextField.text
            emailLabel.text = email
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
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
            
            performSegue(withIdentifier: "orderToStore", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
