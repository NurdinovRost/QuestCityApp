//
//  MainViewController.swift
//  Project
//
//  Created by Ростислав Нурдинов on 07.02.19.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class MainViewController: UIViewController {
    
    var menuVC: MenuViewController!
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestGetState()
        // Do any additional setup after loading the view.
        menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as? MenuViewController
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
        swipeLeft.direction = .left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        view.setGradientBackground(colorOne: Colors.backgroudStartColor, colorTwo: Colors.backgroudCenterColor, colorThree: Colors.backgroudEndColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            showMenu()
        case UISwipeGestureRecognizer.Direction.left:
            hideMenu()
        default: break
        }
    }
    

    @IBAction func menuBarButtonItem(_ sender: UIBarButtonItem) {
        if AppDelegate.isMenuVC {
            showMenu()
        } else {
            hideMenu()
        }
    }
    
    func showMenu() {
        UIView.animate(withDuration: 0.3) { 
            self.menuVC.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.addChild(self.menuVC)
            self.view.addSubview(self.menuVC.view)
            AppDelegate.isMenuVC = false
        }
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.menuVC.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (finished) in
            self.menuVC.view.removeFromSuperview()
            AppDelegate.isMenuVC = true
        }
    }
    
    func requestGetState() {
        let params: [String : String] =
            ["login": "\(NetworkManager.shared.login)"]
        DispatchQueue.main.async {
            Alamofire.request("http://" + "\(NetworkManager.shared.domain)" + "/api/v1.0/getState", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(response)
                    let message = json["message"]
                    let quest_id = json["quest_id"]
                    let team_name = json["team_name"]
                    let times = json["times"].arrayValue
                    let times_complete = json["times_complete"].arrayValue
                    let step = json["step"]
                    let date_now = json["date_now"]
                    let time_now = json["time_now"]
                    NetworkManager.shared.quest_id = quest_id.stringValue
                    NetworkManager.shared.team_name = team_name.stringValue
                    NetworkManager.shared.date_now = date_now.stringValue
                    NetworkManager.shared.time_now = time_now.stringValue
                    for item in times {
                        NetworkManager.shared.times.append(item.stringValue)
                    }
                    for item in times_complete {
                        NetworkManager.shared.times_complete.append(item.stringValue)
                    }
                    
                    if message == "ok" {
                        NetworkManager.shared.step = Int(step.stringValue)!
                    } else {
                        NetworkManager.shared.step = 0
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }

}





