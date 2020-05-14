//
//  MyCartViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/8/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class MyCartViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var arrayOfnames:[String] = []
    var arrayOfprices:[String] = []
    var arrayOfquantities:[String] = []
    var arrayOfproductNumbers:[String] = []
    var total:String = ""
    var cartDictionary:NSDictionary = [:]
    var cdata:NSArray = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfnames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.cartTableView.dequeueReusableCell(withIdentifier: "cartcell") as! CartTableViewCell
        
        cell.nameLabel.text = arrayOfnames[indexPath.row]
        cell.priceLabel.text = arrayOfprices[indexPath.row]
        cell.quantityLabel.text = arrayOfquantities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        
        let alertVC = UIAlertController(title: "Are you sure?", message: "This will convert the items in your cart to an order. Are you ready? This is permanent!", preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "No wait!", style: .cancel, handler: nil)
        
        let settingsAction = UIAlertAction(title: "I'm ready!", style: .default) { (_) -> Void in
            
            let url1 = NSURL(string: "http://malaksadekapps.com/DBCheckout.php?email="+UserDefaults.standard.string(forKey: "Email")!)
            
            let dataOfURL1 = NSData(contentsOf: url1! as URL)
            
            if (dataOfURL1 != nil) {
                    self.arrayOfnames.removeAll()
                    self.arrayOfproductNumbers.removeAll()
                    self.arrayOfquantities.removeAll()
                    self.arrayOfprices.removeAll()
                    self.totalLabel.text = "0"
                    self.cartTableView.reloadData()
                } else {
                    
                    let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
                    
                    let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
                }
        }
            
        alertVC.addAction(alertActionCancel)
            alertVC.addAction(settingsAction)
        self.present(alertVC, animated: true, completion: nil)
           self.cartTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertVC = UIAlertController(title: "Are you sure?", message: "This will permanently remove this item from your cart!", preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "No wait!", style: .cancel, handler: nil)
        
        let settingsAction = UIAlertAction(title: "Yes, I'm sure!", style: .default) { (_) -> Void in
            
            let url = NSURL(string: "http://malaksadekapps.com/DBRemoveFromCart.php?email="+UserDefaults.standard.string(forKey: "Email")!+"&product="+self.arrayOfproductNumbers[indexPath.row])
            
            let dataOfURL = NSData(contentsOf: url! as URL)
            
            let url1 = NSURL(string: "http://malaksadekapps.com/DBFillCart.php?email="+UserDefaults.standard.string(forKey: "Email")!)
            
            let dataOfURL1 = NSData(contentsOf: url1! as URL)
            
            do {
                if (dataOfURL1 != nil) {
                    self.cdata = try JSONSerialization.jsonObject(with: dataOfURL1! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                }
            } catch {
                
                let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
            }
            
            if (self.cdata.count != 0) {
                
                self.cartDictionary = self.cdata[0] as! NSDictionary
                
                if (self.cartDictionary["Total"] as? String) != nil
                {
                    self.total = self.cartDictionary["Total"] as! String
                }
                else {
                    self.total = "0"
                }
                
                self.arrayOfproductNumbers.removeAll()
                self.arrayOfquantities.removeAll()
                self.arrayOfnames.removeAll()
                self.arrayOfprices.removeAll()
                self.totalLabel.text = self.total
                
                for i in 1..<self.cdata.count{
                    
                    self.cartDictionary = self.cdata[i] as! NSDictionary
                    self.arrayOfnames.append(self.cartDictionary["ProductName"] as! String)
                    self.arrayOfprices.append(self.cartDictionary["ProductPrice"] as! String)
                    self.arrayOfquantities.append(self.cartDictionary["ProductStock"] as! String)
                    self.arrayOfproductNumbers.append(self.cartDictionary["ProductNumber"] as! String)
                }
                
                self.cartTableView.reloadData()
                
            } else {
                
                let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
            }
            
            }
        alertVC.addAction(alertActionCancel)
        alertVC.addAction(settingsAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "cartToMenu", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = total
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
