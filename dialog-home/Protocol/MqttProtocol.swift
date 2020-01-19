import Foundation

protocol MqttProtocolDelegate {
    func transferReceiveMessage(name: String, creationDate: String)
}
