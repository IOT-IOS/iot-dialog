import Foundation

struct DialogTableView {
    public var textResponse: String?
    public var creationDate: String?
}

struct DialogGoogleHome: Codable {
    var action: String
    var response: String
}

extension DialogTableView: CustomStringConvertible {
    var description: String {
        return "\(self.textResponse ?? ""), \(self.creationDate ?? "")"
    }
}
