import UIKit
import Alamofire
import SwiftyJSON

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {


    @IBOutlet weak var windowTeamView: UIView!
    
    @IBOutlet weak var btnLogo: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var labelNameTeam: UILabel!
    
    let myTitle = ["Команда", "Список квестов", "Задания"]
    let myTags = [1, 2, 3]
    let myIcon = ["team", "list", "star"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.delegate = self
        menuTableView.dataSource = self
        self.menuTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        windowTeamView.setGradientWindow(colorOne: Colors.windowTeamFirstColor, colorTwo: Colors.windowTeamSecondColor)
        
        btnLogo.layer.cornerRadius = btnLogo.frame.size.width / 2
        labelNameTeam.text = NetworkManager.shared.team_name

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelNameTeam.text = NetworkManager.shared.team_name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableViewCell
        cell.labelText.text = myTitle[indexPath.row]
        cell.btnNavigation.tag = myTags[indexPath.row]
        cell.imageIcon.image = UIImage(named: myIcon[indexPath.row])
        return cell
    }

    @IBAction func btnNavigationAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC")
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            requestListOfQuests()
        case 3:
            //requestListOfTasks()
            let vc = storyboard?.instantiateViewController(withIdentifier: "TaskVC")
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            break
        }
    }
    
    // Список квестов (карточек)
    func requestListOfQuests() {
        func convert(date: String, time: String) -> String {
            let temp_date: Float = Float(date)! * 86400.0
            let temp_time: Float = Float(time)!
            let unixtimeInterval = temp_date + temp_time
            let date = Date(timeIntervalSince1970: TimeInterval(unixtimeInterval))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            return strDate
        }
        
        NetworkManager.shared.itemListArray.removeAll()
        DispatchQueue.main.async {
            Alamofire.request("http://" + "\(NetworkManager.shared.domain)" + "/api/v1.0/listOfQuests", method: .post, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    var cc = 0
                    let message = json["message"]
                    //let count = json["count"]
                    if let list_of_quests = json["list_of_quests"].array {
                        for item in list_of_quests {
                            let quest_id = item["quest_id"].stringValue
                            let name = item["name"].stringValue
                            let place = item["place"].stringValue
                            let date = item["date"].stringValue
                            let time = item["time"].stringValue
                            let duration = item["duration"].stringValue
                            let datetime = convert(date: date, time: time)
                            NetworkManager.shared.dictionary[cc] = quest_id
                            NetworkManager.shared.itemListArray.append(List(name: name, place: place, date: datetime, duration: duration, quest_id: cc))
                            cc += 1

                        }
                        
                    }
                    if message == "ok" {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListVC")
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    
    
    
    
    
}
