import Foundation

enum NetworkError: Error, LocalizedError {
  case noConnection
  case serverError(statusCode: Int)
  case decodingFailed(error: Error)
  case badRequest(error: Error)
  case unknown(error: Error)

  var errorDescription: String? {
    switch self {
    case .noConnection: return "No internet connection. Please check your settings."
    case .serverError(let code): return "Server error with status code: \(code)"
    case .decodingFailed: return "Failed to process data from the server."
    case .badRequest: return "Invalid request. Please try again later."
    case .unknown: return "An unknown error occurred."
    }
  }
}
