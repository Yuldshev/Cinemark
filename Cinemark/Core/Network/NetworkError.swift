import Foundation

enum NetworkError: Error, LocalizedError {
  case noConnection
  case timeout
  case connectionLost
  case serverError(statusCode: Int)
  case decodingFailed(error: Error)
  case badRequest(error: Error?)
  case unknown(error: Error)
  
  var errorDescription: String? {
    switch self {
      case .noConnection: return "No internet connection. Please check your settings."
      case .timeout: return "Request timed out. Please try again."
      case .connectionLost: return "Connection lost during request. Please try again."
      case .serverError(let code): return "Server error with status code: \(code)"
      case .decodingFailed: return "Failed to process data from the server."
      case .badRequest: return "Invalid request. Please try again later."
      case .unknown: return "An unknown error occurred."
    }
  }
}
