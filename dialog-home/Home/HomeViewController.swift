import UIKit
import WatchConnectivity
import SwiftyPlistManager

class HomeViewController: UIViewController {
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    @IBOutlet var dialogTableView: UITableView!
    var dialog = [DialogTableView]()
    var dateManager: DateManager = DateManager()
    var mqttManager: MqttManager = MqttManager()
    var watchSessionManager: WatchSessionManager = WatchSessionManager()
    var requestManager: RequestManager = RequestManager()
    private var api: Api = Api()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.initTableView()
        self.dialogTableView.separatorInset =  UIEdgeInsets.zero
        self.mqttManager.delegate = self
        self.watchSessionManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.watchSessionManager.initOptionsSession()
    }
    
    private func initTableView() {
        self.dialogTableView.register(UINib(nibName: "DialogTableViewCell", bundle: nil), forCellReuseIdentifier: "Dialog")
        self.dialogTableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dialog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dialog", for: indexPath) as! DialogTableViewCell
        let row = self.dialog[indexPath.row]
        if let dialog = row as? DialogTableView {
            cell.backgroundColor = UIColor.white
            cell.draw(dialog: dialog)
        }
        return cell
    }
}

extension HomeViewController: WatchSessionProtocolDelegate {
    func transferDataReceive(interactText: String, creationDate: String) {
        self.dialog.append(DialogTableView(textResponse: interactText, creationDate: creationDate))
        DispatchQueue.main.async {
            self.dialogTableView.reloadData()
        }
        self.requestManager.postDialog("\(api.url)history/talk", data: [
            "name": interactText,
            "creationDate": creationDate,
            "device": "Smartwatch"
        ])
    }
}

extension HomeViewController: MqttProtocolDelegate {
    func transferReceiveMessage(name: String, creationDate: String) {
        self.dialog.append(DialogTableView(textResponse: name.replacingOccurrences(of: "\"", with: ""), creationDate: creationDate))
        DispatchQueue.main.async {
            self.dialogTableView.reloadData()
        }
        self.requestManager.postDialog("\(api.url)history/talk", data: [
            "name": name.replacingOccurrences(of: "\"", with: ""),
            "creationDate": creationDate,
            "device": "Google-Home"
        ])
    }
}
