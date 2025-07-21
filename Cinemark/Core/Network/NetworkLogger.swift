import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
  let queue = DispatchQueue(label: "networklogger.queue")
  
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    if let statusCode = response.response?.statusCode {
      print("⬅️ Status: \(statusCode)")
    }
    
    if let error = response.error {
      print("❌ Error: \(error)")
    }
  }
}
