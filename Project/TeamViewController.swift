//
//  TeamViewController.swift
//  Project
//
//  Created by Ростислав Нурдинов on 07.02.19.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TeamViewController: UIViewController {
    
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var labelLogin: UILabel!
    
    @IBOutlet weak var btnLeaveTeam: UIButton!
    @IBOutlet weak var labelNameTeam: UITextField!
    
    var checked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: Colors.backgroudStartColor, colorTwo: Colors.backgroudCenterColor, colorThree: Colors.backgroudEndColor)
        
        btnLeaveTeam.setGradientWindow(colorOne: Colors.buttonLeaveTeamFirstColor, colorTwo: Colors.buttonLeaveTeamSecondColor)
        labelLogin.text = NetworkManager.shared.login
        textFieldPassword.text = NetworkManager.shared.password
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBtnCheck(_ sender: UIButton) {

        if checked {
            sender.setImage(UIImage(named: "eye-off"), for: UIControl.State())
            textFieldPassword.isSecureTextEntry = true
            checked = false
        } else {
            sender.setImage(UIImage(named: "eye"), for: UIControl.State())
            textFieldPassword.isSecureTextEntry = false
            checked = true
        }
        
    }

    
    
    @IBAction func btnLeaveQuest(_ sender: UIButton) {
        if NetworkManager.shared.quest_id != "" && NetworkManager.shared.step != 0 {
            requestLeaveQuest()
        }
    }
    
    
    @IBAction func btnCrateNameTeam(_ sender: UIButton) {
        requestRenameTeam()
    }
    
    func requestRenameTeam() {
        let params: [String : String] =
            ["login": "\(NetworkManager.shared.login)",
             "team_name": "\(labelNameTeam.text!)",
        ]
        if true {
            DispatchQueue.main.async {
                Alamofire.request("http://" + "\(NetworkManager.shared.domain)" + "/api/v1.0/renameTeam", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let message = json["message"]
                        if message == "ok" {
                            NetworkManager.shared.team_name = self.labelNameTeam.text!
                            self.labelNameTeam.text = ""
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        }
    }
    
    @IBAction func btnLeaveQUest(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "logVC")
        self.present(vc!, animated: true, completion: nil)
    }
    
}


func requestLeaveQuest() {
    let params: [String : String] =
        ["login": "\(NetworkManager.shared.login)",
            "quest_id": "\(NetworkManager.shared.quest_id)",
    ]
    if true {
        DispatchQueue.main.async {
            Alamofire.request("http://" + "\(NetworkManager.shared.domain)" + "/api/v1.0/leaveQuest", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let message = json["message"]
                    if message == "ok" {
                        NetworkManager.shared.quest_id = ""
                        print("gege")
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
}
