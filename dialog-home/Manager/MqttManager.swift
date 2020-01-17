import Foundation
import SwiftMQTT
import SwiftyPlistManager

class MqttManager {
    var mqtt: MQTTSession!
    var delegate: MqttProtocolDelegate?
    
    init() {
        self.initMqtt()
    }
    
    private func getAdafruitConfig(key: String) -> String {
        guard let value = SwiftyPlistManager.shared.fetchValue(for: key, fromPlistWithName: "Adafruit") as? String else {
            return ""
        }
        return value
    }
    
    private func initMqtt() {
        mqtt = MQTTSession(host: self.getHost(), port: 8883, clientID: "swift", cleanSession: true, keepAlive: 30, useSSL: true)
        mqtt.username = self.getUsername()
        mqtt.password = self.getPassword()
        
        mqtt.connect { error in
            if error == .none {
                print("Connected!")
                self.subscribeChannel(topic: "Titi78/feeds/dialog-feeds.interact")
            } else {
                print(error.description)
            }
        }
        mqtt.delegate = self
    }
    
    private func getHost() -> String {
        return getAdafruitConfig(key: "Host")
    }
    
    private func getUsername() -> String {
        return getAdafruitConfig(key: "Username")
    }
    
    private func getPassword() -> String {
        return getAdafruitConfig(key: "Key")
    }
    
    private func subscribeChannel(topic: String) {
        mqtt.subscribe(to: topic, delivering: .atLeastOnce) { error in
            if error == .none {
                print("Subscribed")
            } else {
                print(error.description)
            }
        }
    }
}

extension MqttManager: MQTTSessionDelegate {
    func mqttDidReceive(message: MQTTMessage, from session: MQTTSession) {
        guard let mqttMessage = message.stringRepresentation else { return }
        guard let data = mqttMessage.data(using: String.Encoding.utf8) else { return }
        let text: String = String(decoding: data, as: UTF8.self)
        delegate?.transferReceiveMessage(data: text)
    }
    
    func mqttDidAcknowledgePing(from session: MQTTSession) {}
    
    func mqttDidDisconnect(session: MQTTSession, error: MQTTSessionError) {
        if error == .none {
            print("Successfully disconnected from MQTT broker")
        } else {
            print(error.description)
        }
    }
}
