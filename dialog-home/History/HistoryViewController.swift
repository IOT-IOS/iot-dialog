import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet var historyTableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    var history = [HistoryTableView]()
    private var requestManager = RequestManager()
    private var api: Api = Api()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
        self.historyTableView.separatorInset =  UIEdgeInsets.zero
        self.getHistory()
    }
    
    private func initTableView() {
        self.historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "History")
        self.historyTableView.dataSource = self
    }
    
    private func getHistory(device: String = "") {
        self.requestManager.getHistory(url: "\(api.url)history/talks?device=\(device)", completion: { result in
            switch result {
                case .failure(let error): print(error)
                case .success(let value):
                    self.history = []
                    value.forEach { result in
                        guard let name = result["name"] as? String else { return }
                        guard let creationDate = result["creation_date"] as? String else { return }
                        self.history.append(HistoryTableView(name: name, creationDate: creationDate))
                    }
                     DispatchQueue.main.async {
                        self.historyTableView.reloadData()
                    }
            }
        })
    }
    @IBAction func choicheSelected(_ sender: UISegmentedControl) {
        let text = sender.titleForSegment(at: sender.selectedSegmentIndex)
        guard let device = text else { return }
        self.getHistory(device: device)
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "History", for: indexPath) as! HistoryTableViewCell
        let historyRow = self.history[indexPath.row]
        cell.backgroundColor = UIColor.white
        cell.separatorInset = UIEdgeInsets.zero
        cell.draw(history: historyRow)
        return cell
    }
}
