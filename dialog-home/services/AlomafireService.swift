import Foundation
import Alamofire

class AlamofireService {
    func getRequest(url: String) {
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch(response.result) {
                    case .success(let json):
                        print(json)
                        DispatchQueue.main.async {
                            
                        }
                    case .failure(let error):
                        print(error)
                }
        }
    }
}
