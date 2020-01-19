import Foundation

struct HistoryTableView {
    public var name: String?
    public var creationDate: String?
}

extension HistoryTableView: CustomStringConvertible {
    var description: String {
        return "\(self.name ?? ""), \(self.creationDate ?? "")"
    }
}
