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
    
    var dictionary = [Int: String]()
    var timeTask = 0
    var timeAll = 0
    var timer: Timer?
    var password = ""
    let domain = "...."
    let domainStatic = "http://..../quest_images/"
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
