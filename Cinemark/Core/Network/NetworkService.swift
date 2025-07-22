import Foundation
import Alamofire

protocol NetworkServiceProtocol {
  func request<T: Decodable>(_ endpoint: APIEndpoints) async throws -> T
  func createRequestToken() async throws -> String
  func createSession(with requestToken: String) async throws -> String
}

final class NetworkService: NetworkServiceProtocol {
  static let shared = NetworkService()
  
  let session: Session
  
  private init() {
    let configuration = URLSessionConfiguration.default
    // Увеличиваем таймауты для стабильной работы с TMDB API
    configuration.timeoutIntervalForRequest = 30 // таймаут для запроса
    configuration.timeoutIntervalForResource = 60 // общий таймаут для ресурса
    
    // Настройки для лучшей производительности
    configuration.waitsForConnectivity = true
    configuration.allowsCellularAccess = true
    configuration.httpMaximumConnectionsPerHost = 5
    
    self.session = Session(
      configuration: configuration,
      eventMonitors: [NetworkLogger()]
    )
  }
  
  func request<T>(_ endpoint: APIEndpoints) async throws -> T where T : Decodable {
    do {
      return try await session.request(endpoint)
        .validate()
        .serializingDecodable(T.self)
        .value
    } catch {
      throw mapError(error)
    }
  }
  
  func createRequestToken() async throws -> String {
    let endpoint = APIEndpoints.authRequestToken
    let response: RequestTokenResponse = try await requestWithRetry(endpoint, maxRetries: 3)
    return response.requestToken
  }
  
  // Метод с повторными попытками для критических запросов
  private func requestWithRetry<T: Decodable>(_ endpoint: APIEndpoints, maxRetries: Int = 3) async throws -> T {
    var lastError: Error?
    
    for attempt in 0...maxRetries {
      do {
        return try await request(endpoint)
      } catch {
        lastError = error
        
        // Не повторяем попытки для определенных типов ошибок
        if let networkError = error as? NetworkError {
          switch networkError {
            case .serverError(let code) where code >= 400 && code < 500:
              // Клиентские ошибки - не повторяем
              throw error
            case .decodingFailed:
              // Ошибки декодирования - не повторяем
              throw error
            default:
              break
          }
        }
        
        // Если это последняя попытка, выбрасываем ошибку
        if attempt == maxRetries {
          throw error
        }
        
        // Экспоненциальная задержка: 1s, 2s, 4s
        let delay = pow(2.0, Double(attempt))
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
      }
    }
    
    throw lastError ?? NetworkError.unknown(error: NSError(domain: "NetworkService", code: -1))
  }
  
  func createSession(with requestToken: String) async throws -> String {
    let endpoint = APIEndpoints.authCreateSession(token: requestToken)
    let response: SessionResponse = try await request(endpoint)
    return response.sessionId
  }
  
  private func mapError(_ error: Error) -> NetworkError {
    if let afError = error as? AFError {
      switch afError {
        case .sessionTaskFailed(let urlError as URLError):
          switch urlError.code {
            case .notConnectedToInternet: return .noConnection
            case .timedOut: return .timeout
            case .networkConnectionLost: return .connectionLost
            default: return .badRequest(error: error)
          }
        case .responseValidationFailed(let reason): 
          if case .unacceptableStatusCode(let code) = reason {
            return .serverError(statusCode: code)
          }
          return .badRequest(error: error)
        case .responseSerializationFailed: return .decodingFailed(error: error)
        default: return .badRequest(error: error)
      }
    }
    return .unknown(error: error)
  }
}
