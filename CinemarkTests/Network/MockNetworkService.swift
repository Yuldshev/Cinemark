import Foundation
@testable import Cinemark

class MockNetworkService: NetworkServiceProtocol {
  var result: Result<Any, NetworkError>!

  func request<T>(_ endpoint: APIEndpoints) async throws -> T where T: Decodable {
    switch result {
    case .success(let data):
        if let typedData = data as? T { return typedData } else {
          fatalError("Mock data type (\(type(of: data)) does not match expected type (\(T.self)")
        }
    case .failure(let error):
        throw error
    case .none: fatalError("MockNetworkService result was not set before calling request")
    }
  }
}
