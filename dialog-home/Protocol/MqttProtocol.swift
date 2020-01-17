import Foundation

protocol MqttProtocolDelegate {
    func transferReceiveMessage(data: String)
}
