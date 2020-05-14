//
//  StoreViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/8/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cdata:NSArray = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfnames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.productsTableView.dequeueReusableCell(withIdentifier: "storecell") as! StoreTableViewCell
        
        cell.nameLabel.text = arrayOfnames[indexPath.row]
        cell.stockLabel.text = arrayOfstocks[indexPath.row]
        cell.priceLabel.text = arrayOfprices[indexPath.row]
        cell.descriptionLabel.text = arrayOfdescriptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productName = arrayOfnames[indexPath.row]
        productPrice = arrayOfprices[indexPath.row]
        productStock = arrayOfstocks[indexPath.row]
        productNumber = arrayOfproductNos[indexPath.row]
        productDescription = arrayOfdescriptions[indexPath.row]
        performSegue(withIdentifier: "storeToCartAlert", sender: nil)
    }
    
    var storeName:String = ""
    var cartDictionary:NSDictionary = [:]
    var arrayOfnames:[String] = []
    var arrayOfNames:[String] = []
    var arrayOfstocks:[String] = []
    var arrayOfdescriptions:[String] = []
    var arrayOfprices:[String] = []
    var arrayOfCategories:[String] = []
    var arrayOfproductNos:[String] = []
    var categories = ""
    var productName:String = ""
    var productStock:String = ""
    var productPrice:String = ""
    var productDescription:String = ""
    var productNumber:String = ""
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
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
                
                arrayOfNames.append(cartDictionary["storeName"] as! String)
                
                arrayOfCategories.append(cartDictionary["storeCat"] as! String)
            }
            
            performSegue(withIdentifier: "storeToSearch", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeNameLabel.text = storeName
        categoriesLabel.text = categories
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "storeToCartAlert"){
            let destVC: CartAlertViewController = segue.destination as! CartAlertViewController
            //sends array of names and images to table
            destVC.storename = self.storeName
            destVC.productname = self.productName
            destVC.productprice = self.productPrice
            destVC.productstock = self.productStock
            destVC.productdescription = self.productDescription
            destVC.productnumber = self.productNumber
        }
        if(segue.identifier == "storeToSearch"){
            let destVC: SearchViewController = segue.destination as! SearchViewController
            destVC.arrayOfnames = self.arrayOfNames
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
