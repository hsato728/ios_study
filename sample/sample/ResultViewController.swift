//
//  ResultViewController.swift
//  sample
//
//  Created by 佐藤浩樹 on 2020/06/24.
//  Copyright © 2020 ALJ. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
     @IBOutlet weak var percentageLabel: UILabel!
    
    //暗記カード画面から受け渡される値
    var correctPercentage = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        //実際の正答率を表示
        percentageLabel.text = String(format:"%d %%", correctPercentage)
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
