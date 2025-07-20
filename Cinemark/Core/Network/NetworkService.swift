import Foundation
import Alamofire

protocol NetworkServiceProtocol {
  func request<T: Decodable>(_ endpoint: APIEndpoints) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
  static let shared = NetworkService()
  private init() {}
  
  func request<T>(_ endpoint: APIEndpoints) async throws -> T where T : Decodable {
    do {
      return try await AF.request(endpoint)
        .validate()
        .serializingDecodable(T.self)
        .value
    } catch {
      throw mapError(error)
    }
  }
  
  private func mapError(_ error: Error) -> NetworkError {
    if let afError = error as? AFError {
      switch afError {
        case .sessionTaskFailed(let urlError as URLError) where urlError.code == .notConnectedToInternet: return .noConnection
        case .responseValidationFailed(let reason): if case .unacceptableStatusCode(let code) = reason {
          return .serverError(statusCode: code)
        }
        case .responseSerializationFailed: return .decodingFailed(error: error)
        default: return .badRequest(error: error)
      }
    }
    return .unknown(error: error)
  }
}
