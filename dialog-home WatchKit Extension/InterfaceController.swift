import WatchKit
import Foundation
import WatchConnectivity
import Alamofire

class InterfaceController: WKInterfaceController {
    @IBOutlet var interactText: WKInterfaceLabel!
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    private var currentDate: String = ""
    private var requestManager: RequestManager = RequestManager()
    private var dateManager: DateManager = DateManager()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.initSession()
        
    }
    
    private func initSession() {
        session?.delegate = self
        session?.activate()
    }
    
    private func sendSessionDatas(text: String, date: String) {
        if WCSession.default.isReachable == true {
            self.session?.transferUserInfo([
                "interactText": text,
                "creationDate": date
            ])
        } else {
            print("Not reachable")
        }
    }
    
    private func setValue(value: String) {
        let newText = String(describing: value)
        self.interactText.setText(newText)
        self.currentDate = self.dateManager.currentDate(format: "dd-MM-yyyy HH:mm")
        self.sendSessionDatas(text: newText, date: self.currentDate)
    }
    
    @IBAction func launchCommand() {
        self.presentTextInputController(withSuggestions: ["Parler avec home.musique", "Joue", "rock", "Joue de la musique électro"], allowedInputMode: .plain, completion: { (res) in
            if let sendText = res?.first {
                self.requestManager.getRequest(url: "https://iot-ios.herokuapp.com/action/dialog?action=\(sendText)", completion: { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                        
                    case .success(let value):
                        guard let action = value["action"] as? String else { return }
                        guard let response = value["response"] as? String else { return }
                        self.setValue(value: action)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.setValue(value: response)
                        }
                    }
                })
            }
        })
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: WCSessionDelegate {
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
    
    
}
