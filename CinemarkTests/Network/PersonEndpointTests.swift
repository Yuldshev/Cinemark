import Foundation
import XCTest
@testable import Cinemark

final class PersonEndpointTests: XCTestCase {
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

  // MARK: - Person Endpoint Tests
  func test_request_personPopular_success() async throws {
    let expectedResponse: ResponseDTO<Person> = try jsonLoader.loadJSON(from: "PersonPopularResponse.json")
    sut.result = .success(expectedResponse)

    let response: ResponseDTO<Person> = try await sut.request(.personPopular(page: 1))

    XCTAssertEqual(response.page, 1)
    XCTAssertEqual(response.results.count, 20)
    XCTAssertEqual(response.results.first?.name, "Джейсон Стэтхэм")
    XCTAssertEqual(response.results.last?.name, "Дэвид Коренсвет")
  }

  func test_request_personID_success() async throws {
    let expectedResponse: DetailPerson = try jsonLoader.loadJSON(from: "PersonIDResponse.json")
    sut.result = .success(expectedResponse)

    let response: DetailPerson = try await sut.request(.personID(1892))

    XCTAssertEqual(response.id, 1892)
    XCTAssertEqual(response.name, "Мэтт Деймон")
  }

  // MARK: - Person NetworkError
  func test_request_failure_error() async {
    let expectedError = NetworkError.serverError(statusCode: 500)
    sut.result = .failure(expectedError)

    do {
      let _: ResponseDTO<Person> = try await sut.request(.tvPopular(page: 1))
      XCTFail("Expected to throw an error, but dit not.")
    } catch {
      XCTAssertEqual(error as? NetworkError, expectedError)
    }
  }

  func test_request_noConnection_error() async {
    let expectedError = NetworkError.noConnection
    sut.result = .failure(expectedError)

    do {
      let _: ResponseDTO<Person> = try await sut.request(.tvTopRated(page: 1))
      XCTFail("Expected to throw an error, but dit not.")
    } catch {
      XCTAssertEqual(error as? NetworkError, expectedError)
    }
  }
}
