import Foundation

enum Secret {
  static var api_key: String {
    guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else {
      fatalError("Not found API_KEY")
    }
    return key
  }
}
