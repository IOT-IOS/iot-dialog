import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject {
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    #if os(iOS)
    public var delegate: WatchSessionProtocolPhoneDelegate?
    #else
    public var delegate: WatchSessionProtocolWatchDelegate?
    #endif
    
    override init() {
        super.init()
        self.initSession()
    }
    
    private func initSession() {
        session?.delegate = self
        session?.activate()
    }
    
    public func initOptionsSession() {
        #if os(iOS)
        guard WCSession.isSupported(),
            WCSession.default.activationState == .activated,
            WCSession.default.isPaired,
            WCSession.default.isWatchAppInstalled
            else { return }
        #else
        guard WCSession.isSupported(),
            WCSession.default.activationState == .activated
            else { return }
        #endif
    }
    
    public func sendSessionDatas(text: String, date: String) {
        if WCSession.default.isReachable == true {
            self.session?.transferUserInfo([
                "interactText": text,
                "creationDate": date
                ])
        } else {
            print("Not reachable")
        }
    }
}

extension WatchSessionManager: WCSessionDelegate {
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    #endif
    
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
        guard let textResponse = userInfo["interactText"] as? String else { return }
        guard let creationDate = userInfo["creationDate"] as? String else { return }
         #if os(iOS)
        delegate?.transferDataReceive(interactText: textResponse, creationDate: creationDate)
        #endif
    }
}

