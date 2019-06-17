//
//  TaskViewController.swift
//  Project
//
//  Created by Ростислав Нурдинов on 09.02.19.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TaskViewController: UIViewController {

    
    //var container: ContainerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestListOfTasks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container" {
            NetworkManager.shared.container = segue.destination as? ContainerViewController
        }
    }


func requestListOfTasks() {
    
    NetworkManager.shared.itemListArray.removeAll()
    DispatchQueue.main.async {
        let params = [
            "login": NetworkManager.shared.login,
            "quest_id": NetworkManager.shared.quest_id,
        ]
        NetworkManager.shared.itemTaskArray.removeAll()
        Alamofire.request("http://" + "\(NetworkManager.shared.domain)" + "/api/v1.0/listOfTasks", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"]
                //let count = json["count"]
                if let tasks = json["tasks"].array {
                    for task in tasks {
                        let task_id = task["task_id"].stringValue
                        let img = task["img"].stringValue
                        let convert = task["content"].stringValue
                        let answers = task["answers"].arrayValue
                        let time = task["time"].stringValue
                        let time_tips = task["time_tips"].arrayValue
                        let tips = task["tips"].arrayValue
                        NetworkManager.shared.itemTaskArray.append(Task(task_id: task_id, img: img, content: convert, answers: answers, time: time, time_tips: time_tips, tips: tips))
                        
                    }
                    
                }
                if message == "ok" {
                    if NetworkManager.shared.step < NetworkManager.shared.itemTaskArray.count {
                        print("STEP  -  " + String(NetworkManager.shared.step))
                        print("COUNT  -  " + String(NetworkManager.shared.itemTaskArray.count))
                        NetworkManager.shared.container.segueIdentifierReceivedFromParent("first")
                    } else {
                        NetworkManager.shared.container.segueIdentifierReceivedFromParent("three")
                    }
                } else {
                    print("???????????????")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

}

