import Foundation
import Alamofire

class RequestManager {
    internal typealias RequestCompletion = (Int?, Error?) -> ()?
    private var completionBlock: RequestCompletion!
    private var sessionManager : SessionManager!
    private var configuration = URLSessionConfiguration.default
    
    init() {
        self.configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        if #available(iOS 11.0, *) {
            self.configuration.waitsForConnectivity = false
        }
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func getDialog(url: String, completion: @escaping (Result<[String: Any]>) -> Void) {
        let task = self.sessionManager.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch(response.result) {
                    case .success(let json):
                        guard let result = json as? [String: Any] else {
                            return
                        }
                        completion(.success(result))
                        break
                    case .failure(let error):
                        completion(.failure(error))
                        break
                }
        }
        task.resume()
    }
    
    func getHistory(url: String, completion: @escaping (Result<[[String: Any]]>) -> Void) {
        let task = self.sessionManager.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch(response.result) {
                case .success(let json):
                    guard let data = json as? [[String: Any]] else { return }
                    completion(.success(data))
                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
        }
        task.resume()
    }
    
    func postDialog(_ url: String, data: [String: Any]) {
        let parameters: [String: Any] = [
            "name": data["name"] ?? "",
            "creation_date": data["creationDate"] ?? "",
            "device": data["device"] ?? ""
        ]
        
        self.sessionManager.request(url,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:])
            .responseJSON {response in
                switch response.result {
                    case .failure(let error): print(error)
                    case .success(let json): print(json)
                }
            }
    }
}
