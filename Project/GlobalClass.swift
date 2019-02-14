//
//  GlobalClass.swift
//  Project
//
//  Created by Ростислав Нурдинов on 11/02/2019.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//
//
import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    var container: ContainerViewController!

    let domain = ""
    let domainStatic = ""
    var team_name = "Name team"
    var login = "login"
    var quest_id = ""
    var times: [String] = []
    var times_complete : [String] = []
    var step : Int = 0
    var date_now = ""
    var time_now = ""
    
    var itemListArray: [List] = {return []}()
    
    var itemTaskArray: [Task] = []



    private init() {}
}
