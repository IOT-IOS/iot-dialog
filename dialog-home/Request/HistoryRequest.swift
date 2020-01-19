import Foundation

class HistoryRequest {
    private var requestManager: RequestManager = RequestManager()
    private var api: Api!
    
    public func getHistory(device: String) -> [String: Any] {
        self.requestManager.getRequest(url: "\(api.url)?device=\(device)", completion: { result in
            switch result {
                case .failure(let error):
                    print(error)
                case .success(let response):
                    print(response)
                }
            }
        )
        return [:]
    }
}
