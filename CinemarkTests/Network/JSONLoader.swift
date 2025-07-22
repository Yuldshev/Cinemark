import Foundation

@Observable
final class JSONLoader {
  static let shared = JSONLoader()

  private init() {}

  func loadJSON<T: Decodable>(from filename: String) throws -> T {
    guard let ulr = Bundle(for: MovieEndpointTests.self).url(forResource: filename, withExtension: nil) else {
      fatalError("Failed to locate \(filename).json")
    }

    let data = try Data(contentsOf: ulr)
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
  }
}
