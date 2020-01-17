import Foundation

class DateManager {
    let currentDate: Date = Date()
    
    public func currentDate(format: String) -> String {
        let formater = DateFormatter()
        formater.dateFormat = format
        return formater.string(from: self.currentDate)
    }
}
