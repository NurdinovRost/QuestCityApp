//
//  FirstViewController.swift
//  Project
//
//  Created by Ростислав Нурдинов on 13/02/2019.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

class FirstViewController: UIViewController {

    // Constraints++++++++++
    
    @IBOutlet weak var lblTextTaskTop: NSLayoutConstraint!
    
    // +++++++++++++++++++++
    
    
    @IBOutlet weak var imgTask: UIImageView!
    
    @IBOutlet weak var lblTimeAll: UILabel!
    @IBOutlet weak var lblTimeTask: UILabel!
    @IBOutlet weak var lblTextTask: UITextView!

    @IBOutlet weak var textFieldAnswer: UITextField!
    
    
    @IBOutlet weak var lblNameTask: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGetState()
        view.setGradientBackground(colorOne: Colors.backgroudStartColor, colorTwo: Colors.backgroudCenterColor, colorThree: Colors.backgroudEndColor)
        lblTextTask.layer.borderWidth = 2
        lblTextTask.layer.borderColor = UIColor.black.cgColor
        //print(NetworkManager.shared.itemTaskArray)
        stopTimer()
        startTimer()

    }

override func viewWillLayoutSubviews() {
    updateView(flag: false)
    if imgTask.isHidden {
        lblTextTaskTop.constant = 8
    } else {
        lblTextTaskTop.constant = 144
    }
}
    
    
    @IBAction func btnActionHintFirst(_ sender: UIButton) {
        requestUseTip(tip_number: sender.tag)
        requestGetState()
        let temp = parseJsonToStr(temp: NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].tips[0])
        createAlert(title: "Подсказка №1", message: temp)
        
    }
    
    @IBAction func btnSendAnswer(_ sender: UIButton) {
        print("BTN SEND START STEP  --  " + String(NetworkManager.shared.step))
        for item in NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].answers {
            if let a = item as? JSON {
                if let string = a.rawString() {
                    if string == textFieldAnswer.text!.lowercased() {
                        requestCompleteTask()
                        NetworkManager.shared.step += 1
                        print("BTN SEND END STEP  --  " + String(NetworkManager.shared.step))
                        textFieldAnswer.text! = ""
                        if NetworkManager.shared.step < NetworkManager.shared.itemTaskArray.count {
                            updateView(flag: true)
                        } else {
                            NetworkManager.shared.container.segueIdentifierReceivedFromParent("three")
                        }
                    }
                } else {
                    print("IDI NAHUY")
                }
            } else {
                print("GEGE")
            }
        }
    }
    
    
    func startTimer() {
        
        if NetworkManager.shared.timer == nil {
            NetworkManager.shared.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if NetworkManager.shared.timer != nil {
            NetworkManager.shared.timer?.invalidate()
            NetworkManager.shared.timer = nil
        }
    }
    
    
    func updateView(flag: Bool) {
        lblTextTask.text = NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].content
        lblNameTask.text = "Задание №" + String(NetworkManager.shared.step + 1)
        
        if NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].img != "" {
            imgTask.isHidden = false
            let url = URL(string: NetworkManager.shared.domainStatic + NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].img)
            imgTask.kf.indicatorType = .activity
            imgTask.kf.setImage(with: url, placeholder: nil)
            imgTask.contentMode = .scaleAspectFit
        } else {
            imgTask.isHidden = true
        }
        
        if flag {
            NetworkManager.shared.timeTask = 0
        }
    }
    
    func convertTime(secs: Int) -> String {
        let hours = secs / 3600
        let mins = secs / 60 % 60
        let secs = secs % 60
        let restTime = ((hours<10) ? "0" : "") + String(hours) + ":" + ((mins<10) ? "0" : "") + String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
        //print(restTime)
        return restTime
    }
    
    func parseJsonToStr(temp: Any) -> String{
        if let a = temp as? JSON {
            if let string = a.rawString() {
                return string
            } else {
                return ""
            }
        } else {
            return ""
        }
            
    }

    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "ok", style: .default) { (action) in }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func updateCounter() {
        lblTimeTask.text = convertTime(secs: NetworkManager.shared.timeTask)
        lblTimeAll.text = convertTime(secs: NetworkManager.shared.timeAll)
        //print("FIRST2")
        NetworkManager.shared.timeAll += 1
        NetworkManager.shared.timeTask += 1
    }
}
    
func requestCompleteTask() {
        
        NetworkManager.shared.itemListArray.removeAll()
        DispatchQueue.main.async {
            let params = [
                "login": NetworkManager.shared.login,
                "quest_id": NetworkManager.shared.quest_id,
                "task_number": String(NetworkManager.shared.step - 1),
                ]
            Alamofire.request("http://" + "\(NetworkManager.shared.domain)" + "/api/v1.0/completeTask", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("IT IS COMPLETE TASK STEP" + String(NetworkManager.shared.step))
                    let message = json["message"]
                   
                    if message == "ok" {
                        
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }

func requestUseTip(tip_number: Int) {
    
    NetworkManager.shared.itemListArray.removeAll()
    DispatchQueue.main.async {
        let params = [
            "login": NetworkManager.shared.login,
            "quest_id": NetworkManager.shared.quest_id,
            "task_number": String(NetworkManager.shared.step - 1),
            "tip_number": String(tip_number)
            ]
        Alamofire.request("http://" + "\(NetworkManager.shared.domain)" + "/api/v1.0/useTip", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"]
                
                if message == "ok" {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
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
                //print(response)
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



