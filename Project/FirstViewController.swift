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
    
    var timeTask : Int = 60
    var timeAll = 10000
    
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
        view.setGradientBackground(colorOne: Colors.backgroudStartColor, colorTwo: Colors.backgroudCenterColor, colorThree: Colors.backgroudEndColor)
        lblTextTask.layer.borderWidth = 2
        lblTextTask.layer.borderColor = UIColor.black.cgColor
        print(NetworkManager.shared.itemTaskArray)
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        updateView(flag: false)

    }

override func viewWillLayoutSubviews() {

    if imgTask.isHidden == true {
        lblTextTaskTop.constant = 8
    } else {
        lblTextTaskTop.constant = 144
    }
}
    
    
    @IBAction func btnActionHintFirst(_ sender: UIButton) {
        let temp = parseJsonToStr(temp: NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].tips[0])
        createAlert(title: "Подсказка №1", message: temp)
    }
    
    @IBAction func btnSendAnswer(_ sender: UIButton) {
        
        imgTask.isHidden = false
        for item in NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].answers {
            if let a = item as? JSON {
                if let string = a.rawString() {
                    if string == textFieldAnswer.text! {
                        NetworkManager.shared.step += 1
                        if NetworkManager.shared.step < NetworkManager.shared.itemTaskArray.count {
                            if NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].img == "qwef" {
                                updateView(flag: true)
                            } else {
                                updateView(flag: true)
                            }
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
    
    func updateView(flag: Bool) {
        lblTextTask.text = NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].content
        lblNameTask.text = "Задание №" + String(Int(NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].task_id.split(separator: "_")[1])! + 1)
        if flag {
            timeTask = 2000
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
        //you code, this is an example
        if timeTask > -1 {
            //print("FIRST1")
            lblTimeTask.text = convertTime(secs: timeTask)
            lblTimeAll.text = convertTime(secs: timeAll)
            //print("FIRST2")
            timeAll += 1
            timeTask -= 1
        } else {
            lblTimeTask.backgroundColor = UIColor.red
            createAlert(title: "ПОШЕЛ НАХУЙ ПИДОР", message: "за мат извени")
        }
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
                    print(response)
                    let message = json["message"]
                   
                    if message == "ok" {
                        if NetworkManager.shared.step < NetworkManager.shared.itemTaskArray.count {
                            if NetworkManager.shared.itemTaskArray[NetworkManager.shared.step].img == "url/id_0" {
                                NetworkManager.shared.container.segueIdentifierReceivedFromParent("first")
                            } else {
                                NetworkManager.shared.container.segueIdentifierReceivedFromParent("second")
                            }
                        } else {
                            print("???????????????")
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }


