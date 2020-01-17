import UIKit

class DialogTableViewCell: UITableViewCell {

    @IBOutlet var creationDateLabel: UILabel!
    @IBOutlet var textResponseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DialogTableViewCell {
    public func draw(dialog: DialogTableView) {
        self.textResponseLabel.text = dialog.textResponse
        self.creationDateLabel.text = dialog.creationDate
    }
}
