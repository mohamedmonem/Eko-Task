//
//  NoInternetViewController.swift
//  Eko Task
//
//  Created by apple on 12/19/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tryAgainButtonPressed(){
        if Reachability.isConnectedToNetwork() == true {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
