//
//  FirstViewController.swift
//  EStore
//
//  Created by Malak Sadek on 8/7/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if(segment.selectedSegmentIndex == 0) {
            performSegue(withIdentifier: "firstToSignUpBuyer", sender: nil)
        }
        else {
            performSegue(withIdentifier: "firstToSignUpSeller", sender: nil)
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "firstToSignIn", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let userDefaults = UserDefaults.standard
        let first = userDefaults.bool(forKey: "First")
        
        if (first) {
            performSegue(withIdentifier: "firstToMenu", sender: nil)
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
