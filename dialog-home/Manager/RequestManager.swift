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
    
    func getRequest(url: String, completion: @escaping (Result<[String: Any]>) -> Void) {
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
}
