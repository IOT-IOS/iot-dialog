import UIKit
import WatchConnectivity
import SwiftyPlistManager

class HomeViewController: UIViewController {
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    @IBOutlet var dialogTableView: UITableView!
    var dialog = [DialogTableView]()
    var dateManager: DateManager = DateManager()
    var mqttManager: MqttManager = MqttManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.initSession()
        self.initTableView()
        self.dialogTableView.separatorInset =  UIEdgeInsets.zero
        self.mqttManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard WCSession.isSupported(),
            WCSession.default.activationState == .activated,
            WCSession.default.isPaired,
            WCSession.default.isWatchAppInstalled
            else { return }
    }
    
    private func initSession() {
        session?.delegate = self
        session?.activate()
    }
    
    private func initTableView() {
        self.dialogTableView.register(UINib(nibName: "DialogTableViewCell", bundle: nil), forCellReuseIdentifier: "Dialog")
        self.dialogTableView.delegate = self
        self.dialogTableView.dataSource = self
    }
}

extension HomeViewController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .activated:
            print("WCS activated")
        case .notActivated:
            print("WCS not activated")
        case .inactive:
            print("WCS inactive")
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print(userInfo)
        guard let textResponse = userInfo["interactText"] as? String else { return }
        guard let creationDate = userInfo["creationDate"] as? String else { return }
        self.dialog.append(DialogTableView(textResponse: textResponse, creationDate: creationDate))
        DispatchQueue.main.async {
            self.dialogTableView.reloadData()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dialog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dialog", for: indexPath) as! DialogTableViewCell
        let row = self.dialog[indexPath.row]
        if let dialog = row as? DialogTableView {
            print(dialog)
            cell.backgroundColor = UIColor.white
            cell.draw(dialog: dialog)
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: MqttProtocolDelegate {
    func transferReceiveMessage(data: String) {
        self.dialog.append(DialogTableView(textResponse: data.replacingOccurrences(of: "\"", with: ""), creationDate: self.dateManager.currentDate(format: "dd-MM-yyyy HH:mm")))
        DispatchQueue.main.async {
            self.dialogTableView.reloadData()
        }
    }
}
