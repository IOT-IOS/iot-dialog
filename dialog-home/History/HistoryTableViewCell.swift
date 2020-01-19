import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var creationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension HistoryTableViewCell {
    public func draw(history: HistoryTableView) {
        self.name.text = history.name
        self.creationDate.text = history.creationDate
    }
}
