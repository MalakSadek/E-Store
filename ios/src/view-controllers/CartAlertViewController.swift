//
//  CartAlertViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/18/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class CartAlertViewController: UIViewController {

    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
     var storename:String = ""
     var productname:String = ""
     var productprice:String = ""
     var productstock:String = ""
     var productdescription:String = ""
     var productnumber:String = ""
    
    var storeName:String = ""
    var categories:String = ""
    var cartDictionary:NSDictionary = [:]
    var arrayOfnames:[String] = []
    var arrayOfStoreNames:[String] = []
    var arrayOfstocks:[String] = []
    var arrayOfdescriptions:[String] = []
    var arrayOfprices:[String] = []
    var arrayOfCategories:[String] = []
    var arrayOfproductNos:[String] = []
    var cdata:NSArray = []
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        let url1 = NSURL(string: "http://malaksadekapps.com/DBStoreFill.php?name="+storename)
        
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
            categories = cartDictionary["Categories"] as! String
            
            for i in 2..<cdata.count{
                
                cartDictionary = cdata[i] as! NSDictionary
                arrayOfStoreNames.append(cartDictionary["ProductName"] as! String)
                arrayOfprices.append(cartDictionary["ProductPrice"] as! String)
                arrayOfstocks.append(cartDictionary["ProductStock"] as! String)
                arrayOfdescriptions.append(cartDictionary["ProductDescription"] as! String)
                arrayOfproductNos.append(cartDictionary["ProductNumber"] as! String)
            }
            
            performSegue(withIdentifier: "cartAlertToStore", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func addToCartButtonPressed(_ sender: Any) {
        
        if(Int(stockLabel.text!)! > 0) {
            
            let url1 = NSURL(string: "http://malaksadekapps.com/DBAddToCart.php?email="+UserDefaults.standard.string(forKey: "Email")!+"&product="+productnumber+"&store="+storename)
            
            let dataOfURL1 = NSData(contentsOf: url1! as URL)
            
            if(dataOfURL1 != nil) {
                stockLabel.text = String(Int(stockLabel.text!)!-1)
            }  else {
                
                let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
            }
            
        }
        else {
            let alertVC = UIAlertController(title: "This item is sold out!", message: "This item is currently out of stock and cannot be added to your cart, check back later.", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
            stockLabel.text = "0"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = productname
        descriptionLabel.text = productdescription
        priceLabel.text = productprice
        stockLabel.text = productstock
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cartAlertToStore"){
            let destVC: StoreViewController = segue.destination as! StoreViewController
            //sends array of names and images to table
            destVC.storeName = self.storename
            destVC.arrayOfnames = self.arrayOfStoreNames
            destVC.arrayOfprices = self.arrayOfprices
            destVC.arrayOfstocks = self.arrayOfstocks
            destVC.arrayOfdescriptions = self.arrayOfdescriptions
            destVC.categories = self.categories
            destVC.arrayOfproductNos = self.arrayOfproductNos
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
