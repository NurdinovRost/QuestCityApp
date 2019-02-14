//
//  ViewController.swift
//  Project
//
//  Created by Ростислав Нурдинов on 07.02.19.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    var teamData: [TeamModel] = []
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBAction func buttonClick(_ sender: UIButton) {
        
        if textName.text! != "" && textPassword.text! != "" {
        
            requestTeamLogin()
            }
            //let vc = storyboard?.instantiateViewController(withIdentifier: "NavigationController")
            //self.present(vc!, animated: false, completion: nil)
        }
    
    
        func requestTeamLogin() {
            let params: [String : String] =
                ["login": "\(textName.text!)",
                    "password": "\(textPassword.text!)",
            ]
            DispatchQueue.main.async {
                Alamofire.request("http://" + "\(NetworkManager.shared.domain)" + "/api/v1.0/loginTeam", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let message = json["message"]
                        let team_name = json["team_name"]
                        print(message)
                        print(team_name)
                        if message == "ok" {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController")
                            NetworkManager.shared.team_name = team_name.stringValue
                            NetworkManager.shared.login = params["login"]!
                            self.present(vc!, animated: false, completion: nil)
                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.setGradientBackground(colorOne: Colors.backgroudStartColor, colorTwo: Colors.backgroudCenterColor, colorThree: Colors.backgroudEndColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}

