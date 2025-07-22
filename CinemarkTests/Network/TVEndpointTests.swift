import Foundation
import XCTest
@testable import Cinemark

final class TVEndpointTests: XCTestCase {
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

  // MARK: - TV Endpoint tests
  func test_request_tvPopular_success() async throws {
    let expectedResponse: ResponseDTO<TV> = try jsonLoader.loadJSON(from: "TVPopularResponse.json")
    sut.result = .success(expectedResponse)

    let response: ResponseDTO<TV> = try await sut.request(.tvPopular(page: 1))

    XCTAssertEqual(response.page, 1)
    XCTAssertEqual(response.results.count, 20)
    XCTAssertEqual(response.results.first?.name, "Watch What Happens Live with Andy Cohen")
    XCTAssertEqual(response.results.last?.name, "Шторм любви")
  }

  func test_request_tvTopRated_success() async throws {
    let expectedResponse: ResponseDTO<TV> = try jsonLoader.loadJSON(from: "TVTopRatedResponse.json")
    sut.result = .success(expectedResponse)

    let response: ResponseDTO<TV> = try await sut.request(.tvTopRated(page: 1))

    XCTAssertEqual(response.page, 1)
    XCTAssertEqual(response.results.count, 20)
    XCTAssertEqual(response.results.first?.name, "Во все тяжкие")
    XCTAssertEqual(response.results.last?.name, "Первый шаг")
  }

  func test_request_tvOnTheAir_success() async throws {
    let expectedResponse: ResponseDTO<TV> = try jsonLoader.loadJSON(from: "TVOnTheAirResponse.json")
    sut.result = .success(expectedResponse)

    let response: ResponseDTO<TV> = try await sut.request(.tvOnTheAir(page: 1))

    XCTAssertEqual(response.page, 1)
    XCTAssertEqual(response.results.count, 20)
    XCTAssertEqual(response.results.first?.name, "Поздней ночью с Сетом Майерсом")
    XCTAssertEqual(response.results.last?.name, "Жители Ист-Энда")
  }

  func test_request_tvID_success() async throws {
    let expectedResponse: DetailTV = try jsonLoader.loadJSON(from: "TVIDResponse.json")
    sut.result = .success(expectedResponse)

    let response: DetailTV = try await sut.request(.tvID(1396))

    XCTAssertEqual(response.id, 1396)
    XCTAssertEqual(response.name, "Во все тяжкие")
  }

  // MARK: - TV NetworkError
  func test_request_failure_error() async {
    let expectedError = NetworkError.serverError(statusCode: 500)
    sut.result = .failure(expectedError)

    do {
      let _: ResponseDTO<TV> = try await sut.request(.tvPopular(page: 1))
      XCTFail("Expected to throw an error, but dit not.")
    } catch {
      XCTAssertEqual(error as? NetworkError, expectedError)
    }
  }

  func test_request_noConnection_error() async {
    let expectedError = NetworkError.noConnection
    sut.result = .failure(expectedError)

    do {
      let _: ResponseDTO<TV> = try await sut.request(.tvTopRated(page: 1))
      XCTFail("Expected to throw an error, but dit not.")
    } catch {
      XCTAssertEqual(error as? NetworkError, expectedError)
    }
  }
}
