//
//  ViewController.swift
//  HelloWorld
//
//  Created by Hiromi Yamamoto on 2020/05/02.
//  Copyright © 2020 ALJ Education Plus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonPushed(_ sender: Any) {
        if myLabel.isHidden == true {
            myLabel.isHidden = false
        }else{
            myLabel.isHidden = true
        }
    }
}
