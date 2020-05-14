//
//  MyStoreViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/8/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class MyStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == ordersTableView) {
            return orderStatus.count
        } else {
            return productName.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == ordersTableView) {
            let cell = self.ordersTableView.dequeueReusableCell(withIdentifier: "myorderscell") as! MyOrdersTableViewCell
            
            cell.priceLabel.text = orderPrice[indexPath.row]
            cell.statusLabel.text = orderStatus[indexPath.row]
            cell.emailLabel.text = orderEmail[indexPath.row]
            return cell
        } else {
            let cell = self.productsTableView.dequeueReusableCell(withIdentifier: "myproductscell") as! MyProductsTableViewCell
            
            cell.nameLabel.text = productName[indexPath.row]
            cell.priceLabel.text = productPrice[indexPath.row]
            cell.stockLabel.text = productStock[indexPath.row]
            cell.descriptionLabel.text = productDescription[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenIndex = String(indexPath.row)
        if(tableView == ordersTableView) {
            chosenPrice = orderPrice[indexPath.row]
            chosenEmail = orderEmail[indexPath.row]
            chosenStatus = orderStatus[indexPath.row]
            
            performSegue(withIdentifier: "updateStatus", sender: nil)
        } else {
            chosenName = productName[indexPath.row]
            chosenPrice = productPrice[indexPath.row]
            chosenStock = productStock[indexPath.row]
            chosenDescription = productDescription[indexPath.row]
            performSegue(withIdentifier: "editProduct", sender: nil)
        }
    }

    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    var storeName:String = ""
    var chosenIndex = ""
    var storeCats:String = ""
    var productName:[String] = []
    var productPrice:[String] = []
    var productStock:[String] = []
    var productDescription:[String] = []
    var orderPrice:[String] = []
    var orderStatus:[String] = []
    var orderEmail:[String] = []
    var chosenName:String = ""
    var chosenPrice:String = ""
    var chosenStock:String = ""
    var chosenDescription:String = ""
    var chosenStatus:String = ""
    var chosenEmail:String = ""
    var arrayOfproductNumbers:[String] = []
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "mystoreToMenu", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeNameLabel.text = storeName
        categoriesLabel.text = storeCats
        
        // Do any additional setup after loading the view.
    }
    @IBAction func addProductButtonPressed(_ sender: Any) {
         performSegue(withIdentifier: "addProduct", sender: nil)
    }
    
    @IBAction func editStoreButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "editStore", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editStore"){
            let destVC: SetupStoreViewController = segue.destination as! SetupStoreViewController
            //sends array of names and images to table
            destVC.source = "edit"
        }
        
        if(segue.identifier == "addProduct"){
            let destVC: ProductAlertViewController = segue.destination as! ProductAlertViewController
            //sends array of names and images to table
            destVC.name = "-"
            destVC.desc = "-"
            destVC.stock = "-"
            destVC.price = "-"
            destVC.type = "add"
            destVC.index = chosenIndex
        }
        
        if(segue.identifier == "editProduct") {
            let destVC: ProductAlertViewController = segue.destination as! ProductAlertViewController
            destVC.name = chosenName
            destVC.desc = chosenDescription
            destVC.stock = chosenStock
            destVC.price = chosenPrice
            destVC.type = "edit"
            destVC.index = chosenIndex
        }
        
        if(segue.identifier == "updateStatus") {
            let destVC: OrderAlertViewController = segue.destination as! OrderAlertViewController
            destVC.price = chosenPrice
            destVC.status = chosenStatus
            destVC.email = chosenEmail
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
