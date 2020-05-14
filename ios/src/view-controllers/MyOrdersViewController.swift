//
//  MyOrdersViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/8/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    var arrayOfnames:[String] = []
    var arrayOfquantities:[String] = []
    var arrayOfstatuses:[String] = []
    var arrayOforderIDs:[String] = []
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfnames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ordersTableView.dequeueReusableCell(withIdentifier: "ordercell") as! OrderTableViewCell
        
        cell.productQuantityLabel.text = arrayOfnames[indexPath.row]+" x "+arrayOfquantities[indexPath.row]
        cell.statusLabel.text = arrayOfstatuses[indexPath.row]
        cell.priceLabel.text = arrayOforderIDs[indexPath.row]
        return cell
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
         performSegue(withIdentifier: "orderToMenu", sender: nil)
    }
    @IBOutlet weak var ordersTableView: UITableView!
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
