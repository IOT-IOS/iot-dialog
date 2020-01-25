import Foundation

struct HistoryTableView {
    public var id: Int?
    public var name: String?
    public var creationDate: String?
}

extension HistoryTableView: CustomStringConvertible {
    var description: String {
        return "\(self.id ?? 0), \(self.name ?? ""), \(self.creationDate ?? "")"
    }
}
