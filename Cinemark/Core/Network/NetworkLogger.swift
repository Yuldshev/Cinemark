import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
  let queue = DispatchQueue(label: "networklogger.queue")
  
  func requestDidResume(_ request: Request) {
    print("==============================")
    print("Request started")
    debugPrint(request)
    print("==============================")
  }
  
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    print("==============================")
    print("Response received")
    
    if let url = response.response?.url?.absoluteString {
      print("URL: \(url)")
    }
    
    if let statusCode = response.response?.statusCode {
      print("Status: \(statusCode)")
    }
    
    switch response.result {
      case .success(_):
        print("✅ Success")
      case .failure(let error):
        print("❌ Error: \(error.localizedDescription)")
    }
    print("==============================")
  }
}
