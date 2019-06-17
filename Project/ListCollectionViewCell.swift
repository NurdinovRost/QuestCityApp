//
//  ListCollectionViewCell.swift
//  Project
//
//  Created by Ростислав Нурдинов on 07.02.19.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var labelDateAndTime: UILabel!
    @IBOutlet weak var labelPlace: UILabel!
    @IBOutlet weak var labelKP: UILabel!
    
    @IBOutlet weak var btnJointToQuest: UIButton!
    @IBOutlet weak var labelNameQuest: UILabel!
    
    var listMenu: List? {
        didSet {
            labelNameQuest.text = listMenu?.name
            labelDateAndTime.text = listMenu?.date
            labelPlace.text = listMenu?.place
            labelKP.text = listMenu?.duration
            btnJointToQuest.tag = (listMenu?.quest_id)!
        }
    }

    @IBAction func btnActionJoinToQuest(_ sender: UIButton) {
        requestToBD(btnTag: sender.tag)
    }
    
    func requestToBD(btnTag: Int) {
        let params: [String : String] =
            ["login": "\(NetworkManager.shared.login)",
                "quest_id": NetworkManager.shared.dictionary[btnTag]!,
        ]
        DispatchQueue.main.async {
            Alamofire.request("http://" + "\(NetworkManager.shared.domain)" + "/api/v1.0/joinToQuest", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let message = json["message"]
                    print(message)
                    if message == "ok" {
                        self.btnJointToQuest.isHidden = true
                        NetworkManager.shared.quest_id = NetworkManager.shared.dictionary[btnTag]!
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
}
