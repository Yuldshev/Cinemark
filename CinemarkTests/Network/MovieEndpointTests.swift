import Foundation
import XCTest
@testable import Cinemark

final class MovieEndpointTests: XCTestCase {
  var sut: MockNetworkService!
  private var jsonLoader = JSONLoader.shared
  
  override func setUp() {
    super.setUp()
    sut = .init()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  //MARK: - Movie Endpoint tests
  func test_request_popularMovies_success() async throws {
    let expectedResponse: ResponseDTO<Movie> = try jsonLoader.loadJSON(from: "MoviePopularResponse.json")
    sut.result = .success(expectedResponse)
    
    let response: ResponseDTO<Movie> = try await sut.request(.moviePopular(page: 1))
    
    XCTAssertEqual(response.page, 1)
    XCTAssertEqual(response.results.count, 20)
    XCTAssertEqual(response.results.first?.title, "Как приручить дракона")
    XCTAssertEqual(response.results.last?.title, "З-О-М-Б-И 4: Рассвет вампиров")
  }
  
  func test_request_topRatedMovies_success() async throws {
    let expectedResponse: ResponseDTO<Movie> = try jsonLoader.loadJSON(from: "MovieTopRatedResponse.json")
    sut.result = .success(expectedResponse)
    
    let response: ResponseDTO<Movie> = try await sut.request(.movieTopRated(page: 1))
    
    XCTAssertEqual(response.page, 1)
    XCTAssertEqual(response.results.count, 20)
    XCTAssertEqual(response.results.first?.title, "Побег из Шоушенка")
    XCTAssertEqual(response.results.last?.title, "Могила светлячков")
  }
  
  func test_request_upcomingMovies_success() async throws {
    let expectedResponse: ResponseDTO<Movie> = try jsonLoader.loadJSON(from: "MovieUpcomingResponse.json")
    sut.result = .success(expectedResponse)
    
    let response: ResponseDTO<Movie> = try await sut.request(.movieUpcoming(page: 1))
    
    XCTAssertEqual(response.page, 1)
    XCTAssertEqual(response.results.count, 20)
    XCTAssertEqual(response.results.first?.title, "Каратэ-пацан: Легенды")
    XCTAssertEqual(response.results.last?.title, "Трансформеры: Начало")
  }
  
  func test_request_nowPlayingMovies_success() async throws {
    let expectedResponse: ResponseDTO<Movie> = try jsonLoader.loadJSON(from: "MovieNowPlayingResponse.json")
    sut.result = .success(expectedResponse)
    
    let response: ResponseDTO<Movie> = try await sut.request(.movieNowPlaying(page: 1))
    
    XCTAssertEqual(response.page, 1)
    XCTAssertEqual(response.results.count, 20)
    XCTAssertEqual(response.results.first?.title, "Как приручить дракона")
    XCTAssertEqual(response.results.last?.title, "Экзотическая свадьба Мэдеи")
  }
  
  func test_request_movieID_success() async throws {
    let expectedResponse: DetailMovie = try jsonLoader.loadJSON(from: "MovieIDResponse.json")
    sut.result = .success(expectedResponse)
    
    let response: DetailMovie = try await sut.request(.movieID(278))
    
    XCTAssertEqual(response.adult, false)
    XCTAssertEqual(response.title, "Побег из Шоушенка")
  }
  
  //MARK: - Movie NetworkError
  func test_request_failure_error() async {
    let expectedError = NetworkError.serverError(statusCode: 500)
    sut.result = .failure(expectedError)
    
    do {
      let _: ResponseDTO<Movie> = try await sut.request(.moviePopular(page: 1))
      XCTFail("Expected to throw an error, but dit not.")
    } catch {
      XCTAssertEqual(error as? NetworkError, expectedError)
    }
  }
  
  func test_request_failure_noConnection() async {
    let expectedError = NetworkError.noConnection
    sut.result = .failure(expectedError)
    
    do {
      let _: ResponseDTO<Movie> = try await sut.request(.moviePopular(page: 1))
      XCTFail("Expected to throw an error, but dit not.")
    } catch {
      XCTAssertEqual(error as? NetworkError, expectedError)
    }
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
