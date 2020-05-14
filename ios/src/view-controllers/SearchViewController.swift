//
//  SearchViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/8/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cartDictionary:NSDictionary = [:]
    var arrayOfnames:[String] = []
    var arrayOfStoreNames:[String] = []
    var arrayOfstocks:[String] = []
    var arrayOfdescriptions:[String] = []
    var arrayOfprices:[String] = []
    var arrayOfCategories:[String] = []
    var arrayOfproductNos:[String] = []
    var categories = ""
    var selectedName:String = ""
    var cdata:NSArray = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfnames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.storeTableView.dequeueReusableCell(withIdentifier: "searchcell") as! SearchTableViewCell
        
        cell.nameLabel.text = arrayOfnames[indexPath.row]
        cell.categoriesLabel.text = arrayOfCategories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = arrayOfnames[indexPath.row]
        
        let url1 = NSURL(string: "http://malaksadekapps.com/DBStoreFill.php?name="+selectedName)
        
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
            performSegue(withIdentifier: "searchToStore", sender: nil)
        } else {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "searchToMenu", sender: nil)
    }
    
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var searchSegmet: UISegmentedControl!
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        var url1:NSURL
        arrayOfnames.removeAll()
        arrayOfCategories.removeAll()
        
        switch(searchSegmet.selectedSegmentIndex) {
        case 0:
            url1 = NSURL(string: "http://malaksadekapps.com/DBSearchProducts.php?Product="+searchTextView.text!)!
            break
        case 1:
            url1 = NSURL(string: "http://malaksadekapps.com/DBSearchCategories.php?Category="+searchTextView.text!)!
            break
        case 2:
            url1 = NSURL(string: "http://malaksadekapps.com/DBSearchStores.php?Store="+searchTextView.text!)!
            break
        default:
            url1 = NSURL(string: "http://malaksadekapps.com/DBFillStores.php")!
            noResultsLabel.isHidden = false
            break
        }
        
        let dataOfURL1 = NSData(contentsOf: url1 as URL)
        
        do {
            if (dataOfURL1 != nil) {
                if(dataOfURL1!.length > 5) {
                     cdata = try JSONSerialization.jsonObject(with: dataOfURL1! as Data, options: [JSONSerialization.ReadingOptions.mutableContainers, JSONSerialization.ReadingOptions.allowFragments]) as! NSArray
                }
            }
        } catch {
            
            let alertVC = UIAlertController(title: "Something went wrong!", message: "Please check your internet connection & try again!", preferredStyle: .alert)
            
            let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertVC.addAction(alertActionCancel)
            self.present(alertVC, animated: true, completion: nil)
        }
        
        arrayOfnames.removeAll()
        arrayOfCategories.removeAll()
        
        for i in 0..<cdata.count {
                    
            cartDictionary = cdata[i] as! NSDictionary
            arrayOfnames.append(cartDictionary["storeName"] as! String)
            arrayOfCategories.append(cartDictionary["storeCat"] as! String)
        }
            
        storeTableView.reloadData()
        if (arrayOfnames.count == 0) {
            noResultsLabel.isHidden = false
        } else {
            noResultsLabel.isHidden = true
        }


    }
    
    @IBOutlet weak var storeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noResultsLabel.isHidden = true
        // Do any additional setup after loading the view.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "searchToStore"){
            let destVC: StoreViewController = segue.destination as! StoreViewController
            //sends array of names and images to table
            destVC.storeName = self.selectedName
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
