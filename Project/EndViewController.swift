//
//  EndViewController.swift
//  Project
//
//  Created by Ростислав Нурдинов on 14/02/2019.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.backgroudStartColor, colorTwo: Colors.backgroudCenterColor, colorThree: Colors.backgroudEndColor)
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
