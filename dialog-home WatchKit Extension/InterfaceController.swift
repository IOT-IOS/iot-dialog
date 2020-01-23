import WatchKit
import Foundation
import Alamofire

class InterfaceController: WKInterfaceController {
    @IBOutlet var interactText: WKInterfaceLabel!
    private var currentDate: String = ""
    private var requestManager: RequestManager = RequestManager()
    private var dateManager: DateManager = DateManager()
    private var watchSessionManager: WatchSessionManager = WatchSessionManager()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.watchSessionManager.delegate = self
    }
    
    private func setValue(value: String) {
        let newText = String(describing: value)
        self.interactText.setText(newText)
        self.currentDate = self.dateManager.currentDate(format: "dd-MM-yyyy HH:mm")
        self.watchSessionManager.sendSessionDatas(text: newText, date: self.currentDate)
    }
    
    @IBAction func launchCommand() {
        self.presentTextInputController(withSuggestions: ["Parler avec home.musique", "Joue", "rock", "Joue de la musique électro"], allowedInputMode: .plain, completion: { (res) in
            if let sendText = res?.first {
                self.requestManager.getDialog(url: "https://iot-ios.herokuapp.com/action/dialog?action=\(sendText)", completion: { result in
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

extension InterfaceController: WatchSessionProtocolWatchDelegate {}
