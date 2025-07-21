import Foundation
import XCTest
@testable import Cinemark

final class NetworkServiceTests: XCTestCase {
  var sut: MockNetworkService!
  
  override func setUp() {
    super.setUp()
    sut = .init()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  //MARK: - Tests
  func test_request_popularMovies_success() async throws {
    let expectedResponse: ResponseDTO<MovieDTO> = try loadJSON(from: "MoviePopularResponse.json")
    sut.result = .success(expectedResponse)
    
    let response: ResponseDTO<MovieDTO> = try await sut.request(.moviePopular(page: 1))
    
    XCTAssertEqual(response.page, 1)
    XCTAssertEqual(response.results.count, 20)
    XCTAssertEqual(response.results.first?.title, "Как приручить дракона")
    XCTAssertEqual(response.results.last?.title, "З-О-М-Б-И 4: Рассвет вампиров")
  }
  
  func test_request_failure_error() async {
    let expectedError = NetworkError.serverError(statusCode: 500)
    sut.result = .failure(expectedError)
    
    do {
      let _: ResponseDTO<MovieDTO> = try await sut.request(.moviePopular(page: 1))
      XCTFail("Expected to throw an error, but dit not.")
    } catch {
      XCTAssertEqual(error as? NetworkError, expectedError)
    }
  }
  
  func test_request_failure_noConnection() async {
    let expectedError = NetworkError.noConnection
    sut.result = .failure(expectedError)
    
    do {
      let _: ResponseDTO<MovieDTO> = try await sut.request(.moviePopular(page: 1))
      XCTFail("Expected to throw an error, but dit not.")
    } catch {
      XCTAssertEqual(error as? NetworkError, expectedError)
    }
  }
  
  //MARK: - Sup methods
  private func loadJSON<T: Decodable>(from filename: String) throws -> T {
    guard let ulr = Bundle(for: NetworkServiceTests.self).url(forResource: filename, withExtension: nil) else {
      fatalError("Failed to locate \(filename).json")
    }
    
    let data = try Data(contentsOf: ulr)
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
  }
}

extension NetworkError: @retroactive Equatable {
  public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
      case (.noConnection, .noConnection): return true
      case let (.serverError(lhsCode), .serverError(rhsCode)): return lhsCode == rhsCode
      case (.decodingFailed, .decodingFailed): return true
      case (.badRequest, .badRequest): return true
      case (.unknown, .unknown): return true
      default: return false
    }
  }
}
